---
author: Florent
date: 2019-05-23 11:14:23+00:00
draft: false
title: Nightly end-to-end Kubernetes infrastructure builds
type: post
url: /blog/2019/nightly-end-to-end-kubernetes-infrastructure-builds/
---

A core tenet of infrastructure as code is automation, which we took to heart when setting up the Kubernetes infrastructure for the frontend applications at Net-a-Porter.

We split our infrastructure-as-code into three main repositories:

Terraform
---------

The Terraform repository sets up the AWS infrastructure, including bringing up an EKS cluster and its related resources: autoscaling groups, S3 buckets, security groups, etc.

Helm
----

The Helm repository bootstraps a Tiller server in the `kube-system` namespace and installs a slew of infrastructure-level Helm charts that we rely on to deploy, monitor and maintain applications running in the cluster. In no particular order, this includes Istio, Prometheus (through the [`prometheus-operator`](https://github.com/helm/charts/tree/master/stable/prometheus-operator)), Fluentbit, ExternalDNS, the Cluster Autoscaler, etc.

"Applications"
--------------

The applications repository creates a base Helm chart that all apps inherit and customise to suit their needs. Additionally, it contains a "default" configuration to install the apps based on this base chart so that we can test changes to the base chart.

<p style="text-align: center;">~</p>

In order to make sure that our automation is as reliable as possible, we decided to exercise it daily by setting up a job that would bring up a full-stack platform from scratch, ensure it is working, and tears it down. This also gives us confidence that new changes to our repos don't break any part of our infrastructure.

What we learned
===============

Our Helm repository bootstraps Tiller with `kubectl apply tiller.yaml`, then install charts with `helm install ...`. The two operations were running back-to-back in our script, and once Tiller's yaml is applied in a new cluster, Tiller will take some time to start up and be ready to install charts. This isn't a problem in "established" clusters as Tiller will already have been installed and be ready, but it is an issue in the first run of our infrastructure automation. We solved this issue by adding a check that ensures Tiller is ready before trying to install Helm charts, with a configurable timeout.

A similar issue appeared when we upgraded istio to version 1.1 and the istio helm chart got broken up into an `istio-init` chart and the main `istio` chart. The istio-init chart is meant to install CRDs in a helm-agnostic way, by using Kubernetes Jobs, which works fine but creates another hidden dependency: the Jobs in charge of creating the CRDs _must_ have finished before the `istio` chart can be installed. We added a script to ensure the jobs were finished, then moved to the simpler option of using helm's `install-crd` hook. This issue in particular has been discussed on [Istio's github](https://github.com/istio/istio/issues/12855), and our solution might change in the future.

We also noticed Elastic Load Balancers piling up in our AWS account after running these automation tests. The AWS integration in AWS means a `Service` of type `LoadBalancer` will automatically create ELBs, and deleting that service will trigger these LoadBalancers to be deleted. However, deleting the cluster in its entirety through `terraform destroy` does _not_ trigger the deletion of individual `Service`s, and ELBs will survive, orphaned. We fixed this by deleting Helm releases (which deletes related `Service`s) before tearing down the infrastructure.

Terraform defaults to a 15 minutes timeout for EKS cluster creation, which is _usually_ fine, but breaks every so often when the creation takes longer than usual. We bumped it up to 30 minutes.

An issue in our Jenkins infrastructure caused builds to fail when pushing git tags back to the repository about 5% of the time, failing the whole build. This wasn't too much of an issue in our day-to-day work as the repo that showed this behaviour wasn't updated very often, but having builds running daily nudged us to look into it some more rather than shrug and relaunch the build. It turned out to be a known issue with our Jenkins setup, and had a workaround that we added into the Jenkinsfile.

Once all our code has been applied and the infrastructure is all set up... We're still not ready to run `curl` tests! DNS propagation in particular means that the URL for our services might not be available straight away, so we have to add another busy loop here to wait until DNS has propagated.

Where are we now
----------------

Our current "nightly builds" run in about 33 minutes, most of the time being spent in spinning up and tearing down the EKS cluster itself, which usually takes between 10 and 15 minutes (each way).

Over the past two weeks, they have been stable (90% success rate), and we're now considering them as a core part of our toolkit for infrastructure development.

Eventually, we would like to enable the software engineering best-practice of a build-per-commit, so that any Pull Request into one of our infrastructure repositories is tested and confirmed working. This currently isn't practical – nobody likes a 30mn delay in a PR – but this is a step closer to this goal. 🤞
