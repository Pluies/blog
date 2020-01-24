---
author: Florent
date: 2020-01-24 11:20:37+00:00
draft: false
title: "Introducing Zeitgeist: dependency management for DevOps"
type: post
url: /blog/2020/introducing-zeitgeist/
---

Developers are spoiled these days.

Every single package management system nowadays will allow a developer to define their project's dependencies in a simple format, whether that's a [cargo.toml](https://doc.rust-lang.org/cargo/reference/manifest.html) in Rust, [Gemfile](https://bundler.io/gemfile.html) for Ruby apps, a [pom.xml](https://maven.apache.org/pom.html) for Maven-based projects, [package.json](https://docs.npmjs.com/files/package.json) for NodeJS, [composer.json](https://getcomposer.org/doc/01-basic-usage.md) in PHP...

Declaring your dependencies and their desired version in a standard, easily-parseable language allows you to track outdated dependencies, make sure you keep up to date with security updates, ensures other developers working on the same project use the same version of dependencies, lets you set up reproducible builds... The benefits are immense, and it's universally acknowledged as a best practice in modern software development.

When it comes to the software engineering subfield of Infrastructure-as-Code (also variously referred to as "devops" or "sre", but I'll use infrastructure-as-code through this post) though, the alternatives become rare. It is possible to follow individual projects through mailing lists, or manually checking for new releases, but this doesn't scale to larger projects.

[Chef](https://www.chef.io/), through its [Chef Supermarket](https://supermarket.chef.io/), probably has the most full-featured dependency management system that I've encountered so far, but it only ensures Chef cookbooks are up-to-date, and they only cover the subset of the infrastructure-as-code that Chef will support. What about your cloud orchestration software? What about Chef's own version?

Part of the problem here is that a modern infrastructure-as-code pipeline will rely on several separate, distinct, pieces of software, depending on which part of the infrastructure is being set up: [Terraform](https://www.terraform.io/), [CloudFormation](https://aws.amazon.com/cloudformation/), Chef/[Ansible](https://www.ansible.com/)/[Puppet](https://puppet.com/), [Helm](https://helm.sh/)... These systems will be written in different languages, follow different versioning schemes, so an overarching dependency management system isn't easy to come by.

But dependency management is a worthy goal, so let's take a crack at it!

Based on the findings above and lessons from the [Kubernetes project's handling of dependencies](https://groups.google.com/forum/?pli=1#!topic/kubernetes-dev/cTaYyb1a18I), I'd like to introduce my attempt at solving this issue: [Zeitgeist](https://github.com/Pluies/zeitgeist).

Introducing [Zeitgeist](https://github.com/Pluies/zeitgeist)
------------------------------------------------------------

Zeitgeist is a language-agnostic dependency checker.

Zeitgeist will let you define your dependencies a YAML file, `dependencies.yaml`, and help you ensure:

- These dependencies versions are consistent within your project
- These dependencies are up-to-date

The key concept that allows Zeitgeist to be language-independent is that dependencies are declared with _a reference to another plain-text file where they are defined for the underlying tool_, so any infrastructure-as-code tool that lets you define your dependencies in plain-text will be supported.

For example, let's say you build your infrastructure via Terraform, and use a pinned version of Terraform to create a Docker container that applies your infrastructure in a reproducible fashion. Your Dockerfile may look something like:

```Dockerfile
FROM alpine:3.10

ENV TERRAFORM_VERSION="0.12.12"

RUN curl -LO https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
 && unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
 && mv terraform /bin

# Install more tools, etc
```

You can define this version of Terraform as a dependency:

```yaml
- name: terraform
  version: 0.12.12
  upstream:
    flavour: github
    url: hashicorp/terraform
  refPaths:
  - path: Dockerfile
    match: TERRAFORM_VERSION
```

And Zeitgeist will check if the version declared in your `dependencies.yaml` is respected in the Dockerfile, and will check Github to ensure this version of Terraform is up-to-date, using [Terraform Releases on Github](https://github.com/hashicorp/terraform/releases).

You may then define an [AMI image](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AMIs.html) for an AutoScaling group [in a Terraform source file](https://www.terraform.io/docs/providers/aws/r/autoscaling_group.html#with-latest-version-of-launch-template) that we'll call `my-asg.tf` as:

```hcl
resource "aws_launch_template" "foobar" {
  name_prefix   = "foobar"
  image_id      = "ami-1a2b3c"
  instance_type = "t2.micro"
}

resource "aws_autoscaling_group" "bar" {
  availability_zones = ["us-east-1a"]
  desired_capacity   = 1
  max_size           = 1
  min_size           = 1

  launch_template {
    id      = "${aws_launch_template.foobar.id}"
    version = "$Latest"
  }
}
```

Now, how do you ensure this AMI stays up to date? What if a new version gets released?

Zeitgeist can take care of that for you! Define the dependency as:

```yaml
- name: my-example-ami
  version: ami-1a2b3c
  scheme: random
  upstream:
    flavour: ami
    owner: somebody
    name: "terraform-example-*"
  refPaths:
  - path: my-asg.tf
    match: image_id
```

And Zeitgeist will let you know when a new version of the AMI is available, based on the owner and a regexp.

Another common issue is when a dependency is used in two different contexts, and these need to be kept in sync. This was the Kubernetes' project most important requirement, and I've followed their solution when designing Zeitgeist.

For example, [Helm](https://helm.sh/) (up to version 3) needs two components:

- `tiller`, the server-side component of Helm, deployed on your Kubernetes cluster
- The `helm` CLI, used locally to interact with `tiller`

But trying to use incompatible versions will result in an error message.

This can be expressed as a dependency with two `refPaths`:

```yaml
- name: helm
  version: 2.12.2
  upstream:
    flavour: github
    url: helm/helm
    constraints: <3.0.0
  refPaths:
  - path: bootstrap/tiller.yaml
    match: gcr.io/kubernetes-helm/tiller
  - path: helper-image/Dockerfile
    match: HELM_LATEST_VERSION
```

And Zeitgeist will ensure these stay in sync with each other as well as check the upstream for updates.

Working with Zeitgeist
----------------------

We have introduced Zeitgeist in our infrastructure-as-code pipeline late last year to check dependencies on deployment and give us a nightly dependency report showing us available updates.

Since then, Zeitgeist has been fulfilling its stated aim of helping us keep our infrastructure up-to-date, but its major benefit in my opinion has been the peace of mind gained by knowing that pinned versions of dependencies _are managed_, and we don't have to worry about them silently falling behind.

Zeitgeist supports Github, AMIs, and Helm as upstreams for version checking, with more in the pipeline!

How do I use it in my own projects?
-----------------------------------

To use Zeitgeist in your own project, create a `dependencies.yaml` and run the `zeitgeist` command-line tool. Pre-build binaries are [available on Github](https://github.com/Pluies/zeitgeist/releases).

[Zeitgeist](https://github.com/Pluies/zeitgeist)'s source code is hosted on Github, licensed under the Apache 2.0 license, written in Go, and contributions, bug reports, and feature suggestions are very welcome!
