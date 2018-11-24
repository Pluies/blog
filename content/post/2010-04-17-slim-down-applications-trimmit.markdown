---
author: Florent
date: 2010-04-17 22:57:53+00:00
draft: false
title: 'Slim down applications: Trimmit'
type: post
url: /blog/2010/slim-down-applications-trimmit/
categories:
- OS X
tags:
- itunes
- OS X
---

Applications on Mac OS typically include a lot of stuff most people won't use daily, especially translations in foreign languages and builds for different architectures (x86, x86_64, PPC and PPC 64 bits).

A handful of utilities exist to trim down applications. I personally use [Trimmit](http://lipidity.com/software/trimmit/), a free-as-in-beer software that gives excellent results, as long as it's used carefully.

For example, let's take the latest version of iTunes (v9.1) under Snow Leopard.

This is the default install:

![iTunes - Original size](/blog/wp-content/uploads/2010/04/iTunes-Original-size.png)

A simple cleanup of foreign languages and compression of TIFF files shrinks iTunes into this more reasonable app:

![iTunes - Cleared languages and tiff](/blog/wp-content/uploads/2010/04/iTunes-Cleared-extended-languages-and-tiff.png)

Trimmit already cut iTunes size by nearly _two thirds_ (!), and iTunes works flawlessly.

That's about the best results I've had with Trimmit, because things get ugly if you want to squeeze it too far.

Still want to push things more? Okay, let's keep only the x86 binaries:

![iTunes - cleared architecture](/blog/wp-content/uploads/2010/04/iTunes-cleared-architecture.png)

That's another 17MB trimmed... But this manipulation breaks iTunes code signature. Which will -if you run OS X firewall, like everyone should- trigger a message asking you if you want to allow iTunes to connect to Internet each time you run it.

Still seem a bit big? Well let's check every option in Trimmit and go for it.

![iTunes - Complete cleanup](/blog/wp-content/uploads/2010/04/iTunes-Complete-cleanup.png)

That's 100kB more freed, but now iTunes crashes at startup. Seems that "useless files" aren't that useless after all.

It's important to keep in mind that Trimmit doesn't work well with any applications.

You should be particularly careful (read: do not try) with Adobe applications and other applications on the [blacklist](http://lipidity.com/software/trimmit/help.php). But overall, the extra space can be a very good thing, especially on small partitions and/or on SSDs.
