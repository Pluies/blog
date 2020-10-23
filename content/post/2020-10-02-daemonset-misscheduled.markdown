---
author: Florent
date: 2020-10-23 16:18:01+00:00
draft: false
title: "\"Warning: KubeDaemonSetMisScheduled\"? What's that about?"
type: post
url: /blog/2020/kube-daemonset-misscheduled/
---

I recently set up the [`kube-prometheus-stack`](https://github.com/prometheus-community/helm-charts/blob/main/charts/kube-prometheus-stack/) Helm chart (formerly known as [`prometheus-operator`](https://github.com/helm/charts/tree/master/stable/prometheus-operator)) on our Kubernetes clusters as $dayjob.

This chart sets up a full monitoring and alerting stack, with Prometheus for metrics collection & retention, Grafana for visualisation, and AlertManager for, well, managing alerts (!).

The out-of-the-box monitoring is awesome: extremely detailed, with a wealth of built-in metrics & alerts. On the other hand, some of the warnings are very twitchy, and may be triggered under normal operations while everything is absolutely fine. It's still a pretty good tradeoff, if you ask me: better to err on the side of over-alerting and have to tune down some alerts than have your cluster in a bad state and not know about it!

We tuned or silenced some alerts that we understood, but one stumped me:

> Warning: KubeDaemonSetMisScheduled (Prometheus prod)
>
> 1 Pods of DaemonSet datadog/datadog-agent are running where they are not supposed to run.

_What!?_ How did that happen?

The alert cleared out after a few minutes, so I didn't give it a second thought - probably a fluke... Until, of course, it came back.

Investigating the Misscheduled DaemonSet
----------------------------------------

A quick google search revealed this had been a problem in the past, and had been discussed as [kube-state-metrics issue #812](https://github.com/kubernetes/kube-state-metrics/issues/812) and [kubernetes-mixin issue #347](https://github.com/kubernetes-monitoring/kubernetes-mixin/issues/347), which tweaked the rule to only raise an alert after 15 minutes rather than immediately.

This means that for some reason, some pods in our DaemonSet are running _where they should not be running_ for over 15 minutes... Looking into prometheus confirmed the metric had been up for quite some time, and sometimes climbed up to 2 or 3 misscheduled pods.

Looking into the cluster confirmed that the DaemonSet was happy it had the correct amount of pods:

```
[15:37:14]~/ λ kubectl -n datadog get daemonset
NAME            DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR   AGE
datadog-agent   26        26        26      26           26          <none>          219d
```

But this number was under the actual number of nodes!

```
[17:37:17]~/ λ kubectl get nodes --no-headers | wc -l
      27
```

Why wouldn't a DaemonSet want to run a pod on each node? That's its only responsibility!

Taints & Tolerations
--------------------

Enter [taints and tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/), one of Kubernetes' scheduling mechanisms.

A node can be _tainted_ with a key, value, and specific effect; usually `NoSchedule`. This informs the Kubernetes scheduler _not_ to schedule pods on this node, for example to wait until the node is ready, or conversely before taking the node offline for maintenance.

This is unless the pod has a _toleration_ matching this taint, which allows the pod to ignore the taint's effect and be scheduled on tainted nodes.

The main limitation of taints & tolerations is that it only applies during _scheduling_, which is the process of assigning a Pod to a Node. Once the pod has been scheduled, regardless of which taints may be applied to the node later on, it will keep on running until completion or eviction.

(Side note: this design decision is one of the reason for the existence of the [kube-descheduler](https://github.com/kubernetes-sigs/descheduler) project, which aims to evict pods when taints that the pod cannot tolerate are added on a node.)

A DaemonSet will try and schedule a given pod on each node, _depending on taints_. For example, if 3 nodes in a 10-node cluster are tainted with a `NoSchedule`, a DaemonSet will only try to schedule pods on the other 7 nodes, rather than across all 10 nodes.

So what about our DaemonSet?
----------------------------

Our pods are not having an issue with the initial scheduling process, which would manifest itself as a [**KubeDaemonSetNotScheduled** alert](https://github.com/prometheus-community/helm-charts/blob/5efe06ddc99a0c04b4feb464e0870a1faf91d5b3/charts/kube-prometheus-stack/templates/prometheus/rules-1.14/kubernetes-apps.yaml#L151-L161). Instead, the problem happens during the Pod's lifecycle, when taints are added to an existing node, and the pod becomes unwelcome on a node.

But what would do that? Let's investigate with `kubectl get nodes -o json | jq '.items[].spec'`, and here's the smoking gun!

`ToBeDeletedByClusterAutoscaler=1601646271:NoSchedule`

We use the [`cluster-autoscaler`](https://github.com/kubernetes/autoscaler/tree/master/cluster-autoscaler) to scale the cluster up & down as needed. When the cluster is too big and a node needs to be disposed of, [`cluster-autoscaler` will](https://github.com/kubernetes/autoscaler/blob/master/cluster-autoscaler/FAQ.md#how-does-scale-down-work):
- Add a taint so that no new pods get scheduled on that node
- Evict all non-daemonset pods running on this node
- Wait until these pods are terminated, and destroy the node

We happen to have some pods running long-lived background workers that can take a while to spin down gracefully, and therefore have a generous `terminationGracePeriodSeconds` of 600. Which means that during this whole 10-minute period, the datadog pod is considered misscheduled - after all, it's running on a node that's tainted against it running there!

Now, we do want the datadog pod to stay up on this node until termination, as it sends logs and metrics from all pods, including these long-lived tasks.

So how did we solve it? Simply by adding the corresponding toleration to the pod:

```yaml
apiVersion: v1
kind: Pod
metadata:
(...)
spec:
(...)
  tolerations:
  - effect: NoSchedule
    key: ToBeDeletedByClusterAutoscaler
    operator: Exists
(...)
```

And the alert went away 🥳
