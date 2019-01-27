---
author: Florent
date: 2019-01-27 16:08:23+00:00
draft: false
title: Kubernetes as a surprisingly affordable platform for personal projects - a follow-up
type: post
url: /blog/2019/kubernetes-surprisingly-affordable-platform-followup/
---

This is a follow-up to Caleb Doxsey's great article, _[Kubernetes: The Surprisingly Affordable Platform for Personal Projects](http://www.doxsey.net/blog/kubernetes--the-surprisingly-affordable-platform-for-personal-projects)_.

I think Caleb is absolutely right in his description of Kubernetes as a great platform even for small projects that would usually end up in "a small VPS somewhere", especially if you already have experience with k8s. I've been using Kubernetes on AWS EC2 instances at work, and I was keen on trying Google's fully-managed experience in GKE, so I followed Caleb's steps and created my own cluster. Here are my takeaways.

Infrastructure / Terraform
==========================

After creating a Google Account for this project, I used Terraform to set up the cluster. This involved a fair amount of trial and error as it was my first use of Terraform on GKE, but it's now working perfectly.

See [the source on Github](https://github.com/Pluies/k8s/blob/master/terraform/main.tf).

A big source of frustration when I first set up the cluster was that some zones ran out of capacity for the preemptible `f1.micro` instances as I was setting things up, which Terraform really didn't like. The cluster spun up a node pool in each AZ, but lack of available instances in one AZ meant the node pool could never reach its target of 1 instance. After a 30-minute Terraform timeout, the cluster was left in an unsalvageable error state. Google Cloud's console showed the cluster was in an error state, and Terraform was adamant the cluster didn't exist at all and wanted to recreate it from scratch. The only solution for this was to delete the cluster from Google Cloud's interface and rerun Terraform, hoping that the capacity issues were solved by this point.

Another gotcha is that these instances are pretty weak (0.2 vCPU and 0.6GB of RAM!), and prone to end up in a `NotReady` or `SchedulingDisabled` state. I'm yet not 100% sure why it happens, but it's knocked my sites down about twice in three months of GKE use. In practice, this isn't _too_ much of an issue, as preemptible instances get recycled pretty often, but do make sure you have external monitoring if you want some visibility on this. FWIW I use [StatusCake's free tier](https://www.statuscake.com/pricing/) and it's been very reliable :)

Actually, speaking of the preemptible instances being terminated after 24 hours... I've seen instances living past this threshold, the oldest one I've observed being a very respectable 6 days. Even now, using `kubectl get nodes` I can see a two-day-old node:

```
[16:01:30]~/ λ kubectl get nodes
NAME                                                  STATUS    ROLES     AGE       VERSION
gke-kube-terraform-201811252108056752-65709ca9-lr52   Ready     <none>    4h        v1.11.5-gke.5
gke-kube-terraform-201811252108056752-cc708ee0-47nm   Ready     <none>    1d        v1.11.5-gke.5
gke-kube-terraform-201811252108056752-e90aaa91-l7fx   Ready     <none>    2d        v1.11.5-gke.5
```

Once again, not being very familiar with GKE, I'm not sure whether this is the same VM _actually_ being run for more than 24 hours, or whether it potentially gets rebooted after 24 hours and Kubernetes "remembers" it as the same node re-joining the cluster. ¯\\\_(ツ)\_/¯

The Cost-Saving Hacks
=====================

DNS setup
---------

The trickiest part of Caleb's setup comes from the fact that we do not want a load-balancer in front of our cluster, as it would quadruple the monthly bill. Instead, we need to create a DNS A record with three entries (the individual IPs of each node in the cluster) and set up nginx as a DaemonSet to accept incoming requests on each machine and redirect them as needed.

The record ends up looking like:

```
[16:02:15]~/ λ dig kube.florentdelannoy.com +noall +answer

; <<>> DiG 9.10.6 <<>> kube.florentdelannoy.com +noall +answer
;; global options: +cmd
kube.florentdelannoy.com. 30	IN	A	34.76.25.145
kube.florentdelannoy.com. 30	IN	A	34.76.34.195
kube.florentdelannoy.com. 30	IN	A	35.240.92.199
```

Any extra records you want to point to your Kubernetes cluster can either be updated in the same way or even more simply be made to be a CNAME of your main Kubernetes record. This very blog uses the CNAME method:

```
[16:02:18]~/ λ dig blog.florentdelannoy.com +noall +answer

; <<>> DiG 9.10.6 <<>> blog.florentdelannoy.com +noall +answer
;; global options: +cmd
blog.florentdelannoy.com. 9257	IN	CNAME	kube.florentdelannoy.com.
kube.florentdelannoy.com. 30	IN	A	34.76.25.145
kube.florentdelannoy.com. 30	IN	A	34.76.34.195
kube.florentdelannoy.com. 30	IN	A	35.240.92.199
```

The update process for your main record needs to be very dynamic: as each of your three instances will be rotated every 24 hours, your Kubernetes A record will change every 8 hours on average. This also means we should pick a short TTL, or we run the risk of DNS resolvers caching outdated responses for too long.

I use OVH as my main provider for DNS hosting rather than Cloudflare as Caleb does, so I used his example and wrote a python script to update OVH DNS records through their API (see [Pluies/ovh_dns_updater on Github](https://github.com/Pluies/ovh_dns_updater)). Unfortunately, I found the OVH API to be pretty unreliable in practice – updates would go through the API successfully, but the corresponding record would not update properly in the OVH's DNS server, or take a while to update despite setting a very small TTL.

This prompted me to turn to Google's own [Cloud DNS](https://cloud.google.com/dns/docs/), their equivalent to [AWS Route53](https://aws.amazon.com/route53/). I delegated the subdomain [kube.florentdelannoy.com](kube.florentdelannoy.com) to Google Cloud DNS by adding an NS record in OVH DNS, and rewrote the same DNS-updating script for Google Cloud DNS: see [Pluies/gcloud_dns_updater on Github](https://github.com/Pluies/gcloud_dns_updater).

This has proven very solid, and Google Cloud's integration means that I can allow my cluster to update its own DNS without having to set up credentials. The downside is the frankly extortionate pricing of _twenty whole American dollar cents per month_ per managed zone - a 4% increase on Caleb's $5 quoted price.

As an aside, Caleb runs his DNS updater as a `Deployment` that runs on a schedule, but really all we need is to update the DNS when a new node comes up. And what construct can we trust to run once per node? A `DaemonSet` obviously! I've set up [a DaemonSet](https://github.com/Pluies/k8s/blob/master/kube/dns/templates/daemonset.yaml) to run this DNS updater script once, then sleeps forever.

Free tier
---------

[GCP's Free Tier](https://cloud.google.com/free/docs/gcp-free-tier) is not for everybody! If you read the docs, the `f1.micro` credits are only available in some US regions:

<blockquote>1 non-preemptible f1-micro VM instance per month in one of the following US regions:<br/>
- Oregon: us-west1<br/>
- Iowa: us-central1<br/>
- South Carolina: us-east1<br/></blockquote>

Same deal for the egress charges:

<blockquote>1 GB network egress from North America to all region destinations per month (excluding China and Australia)</blockquote>

I created my cluster in `europe-west1` as it's the closest GCP region, so I'm not eligible for these free tiers. That said, the wording on the Free Tier page seems to imply that _preemptible_ instances are not covered by this, so I wonder if Caleb's pricing calculation is actually correct?

The free tier also gives you $300 for your first year anyway, so you've got room to experiment and hone your setup as needed.

Overall this setup ends up costing me £7.04 (December 2018), breaking down as follows:

- £6.80: Compute Engine Preemptible Micro instance with burstable CPU running in EMEA: 2228.064 Hours
- £0.16: Cloud DNS ManagedZone: 0.995 Months
- £0.07: Compute Engine Network Inter Zone Egress: 8.346 Gibibytes
- £0.01: Compute Engine Network Internet Egress from EMEA to Americas: 0.055 Gibibytes

Overall Thoughts
================

Despite a few gotchas, I'm really fond of this Kubernetes setup. GKE takes away the pain of installing & upgrading Kubernetes and gives you the full Kubernetes experience for a very reasonable price 👍
