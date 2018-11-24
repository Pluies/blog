---
author: Florent
date: 2010-03-28 22:37:03+00:00
draft: false
title: Insecure startup item disabled
type: post
url: /blog/2010/insecure-startup-item-disabled/
categories:
- OS X
tags:
- OS X
- startup items
---

As a follow-up to my [post about startup items](/blog/2010/startup-items-launch-services-at-boot/), I want to point out that a Startup Item must have proper permissions or it will be disabled at startup with the following message:

[![The error message saying a startup item has been disabled](/blog/wp-content/uploads/2010/03/Insecure-startup-item-disabled.png)
](/blog/wp-content/uploads/2010/03/Insecure-startup-item-disabled.png)

In my case, the files under /Library/StartupItems/MyApache still belonged to me instead of root:wheel.

Fixed with a simple:

    
    mbp:StartupItems florent$ sudo chown -Rv root:wheel /Library/StartupItems/MyApache/
    



It also appears that StartupItems permissions need to be set to 755 (executable/script file) and 644 (plist file) respectively.
