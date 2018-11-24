---
author: Florent
date: 2010-03-25 15:25:13+00:00
draft: false
title: Put OS X to sleep via command-line
type: post
url: /blog/2010/put-os-x-to-sleep-via-command-line/
categories:
- OS X
tags:
- applescript
- minitip
---

When connecting to an OS X box via SSH, you may want to put it to sleep after you're done.

This is no system call to put the computer to sleep that I know of. However, Applescript can do it, and it is trivial to call the OSAScript interpreter in bash.

The following script puts the computer to sleep:

    
```
#!/bin/bash

osascript -e 'tell application "System Events" to sleep'
```


**Edit**: found a better way!

I don't know if this is specific to Snow Leopard, but the following command will work as well without having to use Applescript or administrator rights:

    
    pmset sleepnow
