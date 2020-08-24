---
author: Florent
date: 2020-08-24 14:13:37+00:00
draft: false
title: "KubeCon + CloudNativeCon EU 2020 recap"
type: post
url: /blog/2020/kubecon-recap/
---

Last week saw KubeCon + CloudNativeCon Europe 2020 taking place fully remotely, rather than in-person in sunny Amsterdam. Here are my notes from the conference, and links to talks that I thought were worth mentioning!

Of course, I didn't attend all the talks, so this isn't an exhaustive list – here is [the full schedule](https://events.linuxfoundation.org/kubecon-cloudnativecon-europe/program/schedule/).

I've linked to the presentations on sched, and they should all be posted to YouTube shortly.

A note on swag: there was still some! Besides virtual swag (ebooks, colouring books (!?), screensavers...), companies took either a way socially-conscious approach to swag, by making it into a donation (to the WHO from PagerDuty, other companies to BlackGirlsCode, etc), or made it conditional to more engagement: a demo, raffles, quizzes. Makes sense; I imagine the shipping costs of sending stickers to thousands of people individually would be prohibitive.

Deployments
--

There are efforts underway to create an "Application" resource type that would cover several resources (Deployment, Service, etc), in a logical encapsulation of what makes "an application". I'm a bit skeptical: applications have such different requirements and needs, does it make sense to have a unified application type? But worth keeping an eye on future progress! (It was mentioned in a keynote, but I don't remember which one exactly)

People wanting to go beyond Helm: [Managing Applications in Production: Helm vs. ytt and kapp](https://kccnceu20.sched.com/event/Zetv)

My own criticism of Helm, from using Helm 2 _a lot_ in anger was:
- Tiller. All of it. It's a resource hog, not easily HA-able, and a security nightmare.
- `helm ls` is sooooooo slow
- `helm hist` is soooooo slow... And breaks on the bigger charts (eg prometheus operator) [because it exceeds the maximum size of a gRPC message](https://github.com/helm/helm/issues/4865)!
- The templating language. It's not semantic, so you have to worry about stupid stuff like indentation, or you'll end up with broken yaml (if you're lucky) or _silently broken yaml_ (if you're unlucky).
- Try to deploy a chart for the first time and it fails: you can't just retry! You _have_ to `helm del --purge` your broken chart before retrying.
- And why even need to `--purge` when deleting? I want to delete a chart, just delete it. Don't kinda-sorta delete it but reserve the name so it's impossible to reinstall it.

Helm 3, which took ages to be released, is a huge improvement. It basically fixes all the above (besides the templating language). Congrats to the Helm team 👏

More on these improvements, the migration story, and new features of Helm 3: [Deep Dive into Helm](https://kccnceu20.sched.com/event/Zx4K)

A super rad talk by Ellen Körbes about developer experience in Kubernetes environments: [Toolchains Behind Successful Kubernetes Development Workflows](https://kccnceu20.sched.com/event/Zet3)

Tangentially related, a declarative approach to database migrations rather than usual imperative migrations: [Still Writing SQL Migrations? You Could Use A (Schema)Hero](https://kccnceu20.sched.com/event/Zelq)

This is an extremely interesting take on database schema management, and one of the big highlights of this KubeCon for me. Would definitely recommend checking it out!

Service mesh and related stuff
--

Money quote: "No one should _want_ a service mesh." [Panel: Ask Me Anything About Service Mesh - Lin Sun & Daniel Berg IBM; Christian Posta, Solo.io; Oliver Gould, Buoyant; & Sven Mawson, Google](https://kccnceu20.sched.com/event/ZejT)

Which sums it up pretty well imo. If you *need* the benefits a service mesh brings, though, go ahead!

It looks like the consensus it that Linkerd really nailed the simplicity and ease of use (and Istio... Well, you do the maths). Oh, and Microsoft is also coming up with a new Envoy-based service mesh implementing their mesh management interface, which should be interesting to follow.

See also (very much multi-cluster oriented): [Linkerd Deep Dive](https://kccnceu20.sched.com/event/Zexn)

And a super cool talk from the Linkerd about their CI/CD pipeline: [Booting 5 K8s Clusters on Every Git Push: How Linkerd Leveled Up Its CI](https://kccnceu20.sched.com/event/Zeng)

The Linkerd folks use [KinD](https://kind.sigs.k8s.io/) and remote Docker (with `DOCKER_HOST=ssh://...`), which allows them to spin up a bunch of Kubernetes clusters for each PR. The Remote Docker idea in particular is really powerful – it allows you to bring your own resources to any CI build (they use Github Actions), so that you can for example build on a big beefy machine in your AWS account next to your ECR repos for excellently cached builds + super-fast ECR upload.

Other choice bits
--

The obligatory Monzo talk: [Banking on Kubernetes, the Hard Way, in Production](https://kccnceu20.sched.com/event/Zeot)

Interestingly, hosted offerings have matured enough that if they were to start today, they would _not_ self-host Kubernetes.

A great talk by Laurent Bernaille on DNS in Kubernetes: [Kubernetes DNS Horror Stories (And How to Avoid Them)](https://kccnceu20.sched.com/event/Zepr)

I'm pretty sure there was already a similar talk by Datadog at last Kubecon, but DNS issues never cease to amaze!

Interesting data/experiences from DigitalOcean on cluster upgrades: [20,000 Upgrades Later: Lessons From a Year of Managed Kubernetes Upgrades](https://kccnceu20.sched.com/event/ZepW)

Notably, a warning about validating/mutating webhooks, and a hack to use mutating webhooks to mutate validating webhooks so that they don't apply to `kube-system` and block upgrades.

If you've ever logged into a k8s node and run and docker ps and wondered what the heck all these "pause" containers were... Wonder no more! [Look Ma, No Pause!](https://kccnceu20.sched.com/event/Zenv)

Using shell as an operator: [Go? Bash! Meet the Shell-operator](https://kccnceu20.sched.com/event/Zeo1)

I thought this would be a fun talk in the spirit of "deploying kubernetes on a vacuum cleaner" (KubeCon 2018), but... They actually seem serious in their approach? I'm a bit scared.

You like rust? You'll like this! [The Hidden Generics in Kubernetes' API](https://kccnceu20.sched.com/event/Zeit)

And finally, some veeery scary things a Kubernetes-knowledgeable attacker can do to hide up in your cluster: [Advanced Persistence Threats: The Future of Kubernetes Attacks](https://kccnceu20.sched.com/event/ZesN )

And that's it for my round-up of this year's talks!
