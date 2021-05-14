---
author: Florent
date: 2021-05-14 22:40:11+01:00
draft: false
title: "KubeCon + CloudNativeCon EU 2021 recap"
type: post
url: /blog/2021/kubecon-eu-recap/
---

It's that time of the year again: spring means Kubecon!

# AWS Container Days

Before the main Kubecon started, I attended the AWS Container Days event, live-streamed on Twitch (hip!).

Being AWS, of course it was highly EKS-centric, and very interesting.

AWS is working on their own container-centric linux distribution, called [Bottlerocket](https://github.com/bottlerocket-os/bottlerocket). It sounds like a spiritual successor to CoreOS (my words, not theirs), with a focus on security and transactional, in-place updates. For example, it doesn't have SSH, or even a shell by default, but admin access is possible through [SSM Session Manager](https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager.html), which means all node access will automatically be controlled by IAM and audited in Cloudwatch. Compliance nerds rejoice, this is super cool!

Bottlerocket nodes in Kubernetes updates can be controlled [via an operator](https://github.com/bottlerocket-os/bottlerocket-update-operator). I was hoping this could mean a no-downtime update (like, update everything including kernel like ksplice, restart the kubelet at most and call it a day?), but it still looks like a node reboot is unavoidable. Probably still a faster way to upgrade nodes than the standard "drain old nodes and have the cluster autoscaler bring up new ones", and it keeps the local node data, but it doesn't feel very "immutable-infrastructure"-like.

Also mentioned in passing during one of the sessions: if you're deploying a Service Mesh to enjoy in-transit TLS... You may not need to? Some newer AWS instances do [automagical transparent in-transit encryption](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/data-protection.html#encryption-transit)!

The next session was a peek at the EKS Roadmap.

Looking back at was done in the previous year:
- Security Groups for Pods
- Secrets encryption with KMS
- Secrets manager CSI driver
- Helm support in ECR
- Amazon EKS distro

A look ahead in 2021:
- Version deprecation: AWS describes this as a security feature, which is counter-intuitive but true. Unmaintained versions of k8s are dangerous!
- Guard Duty for k8s audit logs
- Access Entry API
- EKS API PrivateLink
- Bottlerocket in Managed Node Groups
- Signed Image Validation: yess!
- DoD CC SRG (🤷 ?)
- Parallel node groups updates
- Karpenter node provisioning (more on Karpenter further down this blogpost)
- 5mn control plane creation: this is great, hopefully they also bring down the cluster upgrade time. Currently one of my major pet peeve with EKS, as control-plane upgrades regularly take 45mn+
- 15k node clusters
- Cross-cluster service discovery
- Elastic Fabric Adapter (?)
- Prefix delegation: ? this is a new VPC feature, now coming to EKS; will increase pod density
- Node groups Scale-to-Zero
- IPv6 (yay!)
- External clusters in AWS console (as long as they use the EKS distro I believe)
- Cross-account cluster visibility, the same way some other resources can be shared cross-account
- EKS Add-ons expansion:
    - CoreDNS and kube-proxy
    - OpenTelemetry, Fluentbit
    - CSI Drivers
    - Load Balancer Controller
    - Metrics Server
- ^ Yes! This is great! Some of these resources (coredns, kube-proxy..) are set up as part of your cluster when you create it, but are then totally unmanaged and need to be _manually_ upgraded. And they can't easily be brought into something like Helm or Terraform, as they already exist as resources – doing so would mean doing a `terraform import` or similar before managing them, which is very meh. Instead, having them managed along the cluster as add-ons is the right way to go, and I'm looking forward to it being available!
- "EKS Anywhere"
- CDK for k8s
- AWS controllers for k8s
- Application Cost Allocation: this is a great development, as costs within a k8s cluster are currently opaque to the AWS Cost Manager

That's a pretty long laundry list! Looking forward to these, it really shows how serious AWS is about EKS.

Worth noting that the roadmap itself is [available on GitHub](https://github.com/aws/containers-roadmap/projects/1?card_filter_query=label%3Aeks), kudos to AWS for being open & transparent about it!

# Kubecon!

Hey, the conference website is all new and fancy!

Last year's conference website was a throwback to the early-2000s, and was met with an unending stream of complaints in the [CNCF Slack](https://cloud-native.slack.com/) channels. To be fair to the team, organising the whole conference virtually after the pandemic had knocked it off of its scheduled Amsterdam venue in March must have been a huge rush, so getting it going _at all_ was already a win.

And the good news is, the new platform for Kubecon 2021 is _really nice_! It works flawlessly, is fast & responsive, and generally gets out of the way. 🙌

## Wednesday

After the traditional opening keynote, I watched Maciej Szulik & Alay Patel from Red Hat talk about [**The Long, Winding and Bumpy Road to CronJob’s GA**](https://www.youtube.com/watch?v=o5h6s3A9bXY). From ScheduledJobs (*I haven't heard that name in a long time!*) way back in k8s 1.4, renamed to CronJobs in 1.5, all the way to finally reaching GA in 1.21. Interesting discussion on why the CronJob controller needed to be replaced, how it brings much better performance for large number of cronjobs, and the finicky details of what happens when someone changes a CronJob schedule!

Being a Helm user, I of course then watched [**Helm Users! What Flux 2 Can Do For You**](https://www.youtube.com/watch?v=hCTgCRlU-M0), and the answer is: lots of gitopsy stuff! One of my main concerns about GitOps is the "silent failure" pathological case. In a classic deployment pipeline, you get quick and direct feedback on whether a deployment was successful or not, whereas GitOps is more of a "lemme handle that for you and don't worry about it". To address this, Flux 2 has a nice core concept of notification services, which will alert you if deployments fail rather than you having to check the state of Flux.

[**Cortex: Multi-tenant Scalable Prometheus**](https://www.youtube.com/watch?v=VPBKNfRRytg) talks about, well, Cortex. It now supports block storage as well as nosql for storing its metrics, which simplifies administration hugely. This apparently has been done in collaboration with Thanos, it's great to see open-source projects with similar aims working together!

[**Towards CNI v2.0**](https://www.youtube.com/watch?v=h9QYbaJzBe0) is a technical view of what the limitations are with the current CNI interface, how the team is planning to fix them, and a call for comments/concerns. Quite deep & technical, but if you're building a CNI, it's a must-watch.

Datadog has been on a roll at Kubecon by having _absolutely smashing talks_ these past few years, and I was super excited to see Laurent Bernaille was back for [**Ghosts in the Runtime: Who Ate My Capabilities and Other Mysteries**](https://www.youtube.com/watch?v=1bi5H9hMuFY)! Once again, they deliver: esoteric new build flags, sneaky race conditions... One of the great talks of the conference.

Have you ever wondered how your data is safe in a multi-tenant cluster despite PersistentVolumes being non-namespaced? I haven't, which probably shows I'd make a crap security engineer. But Hendrik Land has, and [**CSI Volume Attacks – The SRE Strikes Back**](https://www.youtube.com/watch?v=A9IwOHGt7gM) is an excellent overview of the potential attack vectors, and how they're mitigated.

## Thursday

A quick keynote, and we're off to some auth talk with [**What Do You Mean K8s Doesn't Have Users? How Do I Manage User Access Then?**](https://www.youtube.com/watch?v=_Dzc07aBQHI)! I remember how surprised I was when I first ran into this design choice, and this talks covers it very well, with a broader discussion about recommended auth strategies, RBAC, etc. A fine discussion!

Sysdig covered [**The Art of Hiding Yourself**](https://www.youtube.com/watch?v=Ti5Uj984CLY), which gave me the heebeejeebies – running stuff on the cluster that can't be found with either `kubectl` _or_ `ps` once you're in the machine?? Devious. Lorenzo goes ahead and suggests using [Falco](https://falco.org/) to monitor this kind of suspiscious activity: it looks like a solid project, and I'd love to give it a go!

Ellen Körbes is back for another great talk! After last year's discussion on hot-code reloading when developing on Kube, it's now time to look into [**Hacking into Kubernetes Security for Beginners**](https://www.youtube.com/watch?v=mLsCm9GVIQg). I won't spoil it: if you have to watch just one of this year's crop, make it this one!

The next two talks were about BuildKit, a new backend to build container images: [**BuildKit CLI for kubectl: A New Way to Build Container Images**](https://www.youtube.com/watch?v=vTh6jkW_xtI) and [**Running Cache-Efficient Builds at Scale on Kubernetes with BuildKit**](https://www.youtube.com/watch?v=wTENRhYt3mw). Both are very nice talks, and buildkit itself is pretty awesome: parallelisation of multi-stage builds, build-time cache (for example your Maven's `~/.m2` folder)... Great stuff!

[**Resource Requests and Limits Under the Hood: The Journey of a Pod Spec**](https://www.youtube.com/watch?v=WB3_sV_EQrQ) is a nice overview of resource requests & limits. Who knew that CPU amounts got translated into time slices for containerd!? I didn't!

[**When Prometheus Can’t Take the Load Anymore**](https://www.youtube.com/watch?v=parm7--PQIE) is an excellent rundown of the issues with scaling out-of-the-box Prometheus, and comparison of M3, Cortex and Thanos. If Prometheus is giving you issues, I'd recommend this as a first stop.

[**Sidecars at Netflix: From Basic Injection to First Class Citizens**](https://www.youtube.com/watch?v=YB5rlo2cq9s) is, uh, a "specialist" talk. The two halves don't seem that connected: the first half is a view of the dystopian world of Netflix infra, where an ongoing "migration" from Mesos to Kubernetes includes _writing their own Virtual Kubelet implementation to run stuff via systemd on VMs_, **what!?** The second half is thankfully much saner. A good overview of the current issues with sidecars: no ordering guarantee, can't work with Jobs, can't work on initContainers. Then goes into KEP753 to fix it, why it was abandoned, and what the next steps are. Unfortunately it doesn't look like we're going to see these issues resolved soon, but it's reassuring to know that people are working on it.

More security! [**Uncovering a Sophisticated Kubernetes Attack in Real-Time**](https://www.youtube.com/watch?v=bohnofE_dvw) starts with a great overview of k8s security, re-labelling the oft-mocked sprawling [CNCF Cloud Native landscape](https://landscape.cncf.io/) to the "Threat Landscape" (heheheh). Then it carries on showing what an attack could look like, and how [Cilium](https://cilium.io/) would catch all the steps via eBPF inspecting. If I understand correctly, Cilium runs as a privileged DaemonSet that injects eBPF programs to monitor syscalls, which is _insanely cool_ but also terrifying in the light of known supply-chain attacks like Solarwinds.

And speaking of supply-chain... [**Notary v2: Supply Chain Security for Containers**](https://www.youtube.com/watch?v=SZMbuirEQVU)! Notary v1 brought image signing to docker, but is a bit of a convoluted design, is external to the docker registry, and (per this talk) is basically never used in practice. Notary v2 aims to make this all better by embedding signatures in OCI registries, making them compatible with every single registry out there (yay!). There's apparently a [CNCF white paper on supply-chain security best practices](https://github.com/cncf/tag-security/issues/510): need to check it out! They also talk about "SBOM", I'm not too sure what it refers to, but I assume it make sense to more seasoned "secure supply-chain" folks.

Capping the day with another great talk: [**How to Break your Kubernetes Cluster with Networking**](https://www.youtube.com/watch?v=7qUDyQQ52Uk). How can you not like a talk that opens up with [the DNS haiku](https://www.cyberciti.biz/media/new/cms/2017/04/dns.jpg)? Goes into `ndots` fun, DNS rate limits, NetworkPolicies, kube-proxy iptables v. ipvs, mitm via ExternalIP, CRD watchers creating massive traffic... Very, very nice talk.

## Friday

Straight from the keynote into [**Trust No One: Bringing Confidential Computing to Containers**](https://www.youtube.com/watch?v=zTn9Xt1k1OA). I'm not familiar with the whole world of "trusted computing", but the speakers made their best to make it accessible. Basically, they're trying to run "trusted" (signed & encrypted) containers on an "untrusted" software stack. The trick? Trust the _hardware_, which will confirm that the stack hasn't been tampered with, so you can go ahead and run the signed images. Disclaimer: that's what I understood! Not sure if it's 100% correct! It definitely looks challenging :)

Back to AWS stuff with [**Groupless Autoscaling with Karpenter**](https://www.youtube.com/watch?v=43g8uPohTgc). [Karpenter](https://github.com/awslabs/karpenter) is a new AWS project that wants to replace the venerable [cluster-autoscaler](https://github.com/kubernetes/autoscaler/tree/master/cluster-autoscaler) with a completely new take on node provisioning. It does so by completely bypassing AutoScaling Groups, and instead calling out directly to the EC2 API to provision the exact type of nodes needed. This brings speed improvements, as it takes out the ASG in the middle, and allows for using a wide range of nodes without having to configure an autoscaling group for each type of nodes. In the demo, they scaled a deployment to a few replicas, Karpenter brought up a `c5.xlarge`, then to 100 replicas, and Karpenter responded by casually spinning up a `c5.24xlarge` 😂

Other super cool tidbits: just label your pod with a different `arch` and Karpenter will bring the right type of node (cool!!). Knowing which node a pod will get scheduled to allows for starting to download the needed image(s) before the node even reaches "Ready" status, so the full scale-up time time of "pod unschedulable" -> "pod running" becomes even shorter! And on top of that, Karpenter is spot-cost-aware, and will not only try to get the cheapest spot nodes available, and clean them up nicely when reclaimed, but it will also provision cheaper spot nodes if they appear, and rebalance pods to make better use of resources! So no more need for the [descheduler](https://github.com/kubernetes-sigs/descheduler), or the [node-termination-handler](https://github.com/aws/aws-node-termination-handler)!

Old friends of the blog Jetstack talk about their CertManager project in [**Cert-Manager Beyond Ingress – Exploring the Variety of Use Cases**](https://www.youtube.com/watch?v=wEW2kVKxgss). Anywhere you want certs, CertManager can help you - including for ad-hoc mTLS, and (soon!) kubernetes itself.

Gitlab offer a view into their metrics in [**How We are Dealing with Metrics at Scale on GitLab.com**](https://www.youtube.com/watch?v=6sfr2IGJQXk). Despite a slightly dry title, this talk is an absolute eye-opener, putting words on issues I've been battling with on metrics & alerting for years, and giving concrete and actionable advice on how to overcome them.

I've recently tried to set up autoscaling based on external metrics, which works flawlessly... Until you're trying to use metrics from more than one provider, which is literally impossible. ExternalMetrics only allows for a single source! There is [a proposal](https://github.com/kubernetes-sigs/custom-metrics-apiserver/issues/70) to support more sources, and I've hacked together the [external-metrics-multiplexer](https://github.com/Pluies/external-metrics-multiplexer) to allow using several (with caveats), but a more general solution is KEDA, as discussed in [**Application Autoscaling Made Easy With Kubernetes Event-Driven Autoscaling**](https://www.youtube.com/watch?v=H5eZEq_wqSE). KEDA does _a lot_, including scale-to-zero (yay!) and talks to a huge amount of metrics providers. A great-looking project!

And finally, still about scaling: [**Battle of Black Friday: Proactively Autoscaling StockX**](https://www.youtube.com/watch?v=IqrKFBxf_Dk). Kyle & Mario from StockX show how they started up with fully manual scaling, then turned to the classic cluster-autoscaler+hpa, and then have a very interesting bit about proactive scaling. HPA is indeed great for "classic" traffic patterns where your traffic ramps up slowly enough for your Deployment to scale up along the way, but huge spikes in traffic need some pre-warming, which they do through a little in-house project. Good stuff.

# Wrapping up

That was another great Kubecon! And at $10 for the earlybird entry, by far the best bang-for-your-buck I've seen at a conference.

My (highly coveted I'm sure) Cool Tech Of The Conference awards will go to... *Karpenter*, *Falco*, and *KEDA*!

As for my Three Cool Talks of The Conference, I'll go ahead and nominate:
- [**Hacking into Kubernetes Security for Beginners**](https://www.youtube.com/watch?v=mLsCm9GVIQg)
- [**How We are Dealing with Metrics at Scale on GitLab.com**](https://www.youtube.com/watch?v=6sfr2IGJQXk)
- [**Ghosts in the Runtime: Who Ate My Capabilities and Other Mysteries**](https://www.youtube.com/watch?v=1bi5H9hMuFY)

Looking forward to Kubecon EU 2022, hopefully in person! 🤞
