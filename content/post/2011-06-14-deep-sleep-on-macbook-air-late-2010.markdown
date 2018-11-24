---
author: Florent
date: 2011-06-14 20:14:21+00:00
draft: false
title: Deep sleep on MacBook Air Late 2010
type: post
url: /blog/2011/deep-sleep-on-macbook-air-late-2010/
categories:
- OS X
---

Apple's latest MacBook Air boasts to last 30 days on battery when sleeping. Classical sleep will power down most of the machine (display, processor, hard drive, etc) but keep the RAM powered on in order to keep the state of the OS. However, the RAM drains too much power to realistically allow more than a week or so on a single charge.

The MBA feat is achieved through "deep sleep", i.e. writing the RAM contents to a file on the hard drive, which allows powering down the RAM without losing state (also known as _hibernation_). The only problem is that waking the computer up requires loading back all of this data on RAM, which takes a few seconds.

Apple even uses a trickier approach by default: the computer sleeps normally at first, and switches to deep sleep after a certain amount of time.

This is very easy to see on the MBA: close the lid and reopen it a few minutes later, waking up is super fast. Leave it sleeping for a day, and it will take about ten seconds before you can do anything with it.

While this is a clever solution, the parameters aren't that well adjusted – the computer goes to deep sleep too fast in my opinion.

This can be modified through pmset. First, run it to see what are the active parameters:

    
    
    Air:~ florent$ pmset -g
    Active Profiles:
    Battery Power		-1*
    AC Power		-1
    Currently in use:
     deepsleepdelay	4200
     halfdim	0
     hibernatefile	/var/vm/sleepimage
     disksleep	10
     sleep		10
     hibernatemode	3
     displaysleep	5
     ttyskeepawake	1
     deepsleep	1
     acwake		0
     lidwake	1
    



The interesting one is deepsleepdelay (edit: see footnotes). It represents the time in seconds before switching from classical sleep to deep sleep. 4200 seconds, 70 minutes, is way too short. Let's set it to 24hrs instead:

    
    
    Air:~ florent$ sudo pmset -a deepsleepdelay 86400
    



There it is! Deep sleep will still work, but won't be as annoying.


**Edit July 2, 2011:**
It looks like Apple changed the name of that setting from _deepsleepdelay_ to _standbydelay_ during the update to OS X 10.6.8. The command line has to be changed accordingly:

    
    
    Air:~ florent$ sudo pmset -a standbydelay 86400
    
