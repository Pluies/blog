---
author: Florent
date: 2011-05-07 08:53:33+00:00
draft: false
title: Automatically restart applications on OS X
type: post
url: /blog/2011/automatically-restart-applications-on-os-x/
categories:
- OS X
tags:
- minitip
- OS X
---

I use [GimmeSomeTune](http://www.eternalstorms.at/gimmesometune/GimmeSomeTune/GimmeSomeTune.html) to provide hotkeys and some other goodies for iTunes. It works alright, but is veeeery crashy – usually every dozen hours or so on my machine.

How to fix that? Let's relaunch it as soon as it crashes. Simple!

In a terminal:

```
for (( ; ; )); do open -W /Applications/Multimedia/GimmeSomeTune.app/; done
```

open is the bash command to launch applications on OS X. It works with all kinds of files: open somefile.avi will open that file in your default video player, VLC for example. The -W flag tells open to wait until the application exits before returning any value. By putting it all in a for loop, we effectively ensure that bash will launch GimmeSomeTune, wait until it crashes, then relaunch it, and so on.

**Edit**: this is a bad way of doing things. A better way is described [here](/blog/2011/keep-gimmesometune-running/).
