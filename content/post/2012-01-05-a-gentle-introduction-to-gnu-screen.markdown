---
author: Florent
date: 2012-01-05 06:01:39+00:00
draft: false
title: A gentle introduction to GNU screen
type: post
url: /blog/2012/a-gentle-introduction-to-gnu-screen/
categories:
- UNIX
tags:
- linux
- screen
---

You probably heard of [GNU screen](http://en.wikipedia.org/wiki/GNU_Screen). It's handy, ubiquitous, and dead simple. Here's how to use it!

Open a terminal and type:

    
    screen


You're welcomed by an introduction message, press enter, and... You're in a shell. Uh?

![](/blog/wp-content/uploads/2012/01/Screen-shot-2012-01-05-at-6.52.56-PM.png)


## Screen is simple


screen is a terminal manager, so it's logical that the first thing you see when you start it is a terminal.

This terminal is as vanilla as the terminal we started from. Just try it:

![](/blog/wp-content/uploads/2012/01/Screen-shot-2012-01-05-at-6.52.42-PM.png)

See? No black magic here, simply a terminal.


## Screen is simple


The only difference is that **Ctrl+a** is now a special key combination that you can use to invoke screen's commands.

So let's take a break and quit screen. Type Ctrl+a to let screen know you want its attention, then **d**, as in **detach**. There! You're back in your first terminal.

![](/blog/wp-content/uploads/2012/01/Screen-shot-2012-01-05-at-6.56.48-PM.png)

Let's go back in screen and learn some more! Just type:

    
    screen -r


The **-r** stands for **reattach**: screen will re-open the last session, the one we detached from. You can see the results of the commands we entered earlier are still here.

We just saw a great feature of screen: the ability to log out and log back in without losing anything. Do you have something long to on a server? SSH into the server, launch screen, launch the task, detach from screen, log out from SSH, go back home, enjoy a good dinner and a well-deserved night of sleep, come back to work, SSH into the server, launch screen -r, and it's just as if you never left.



## Screen is simple



You can already use screen just like that, but let's just see another nifty feature: multiple terminals!

In screen, type Ctrl-a, then 'c', short for **create**. You're in a shell. Uh?



## Screen is simple



You just created another terminal. screen can manage plenty of simultaneous terminals, not just one. To see a list of them, type Ctrl+a, then the quote symbol ", and you will see your two terminals. Just use the arrows to select which one you want to open.

![](/blog/wp-content/uploads/2012/01/Screen-shot-2012-01-05-at-6.52.33-PM.png)

There you go, you know screen! See, I told you it was simple.


## Misc useful commands


Do you want to change the name of a terminal in screen's list? In that terminal, Ctrl+a and A.
Do you want to go directly to a specific terminal? Ctrl+a and its number.
Do you want to go to the **p**revious/**n**ext terminal? Ctrl+a and p or n.
Do you want to switch to the previous terminal quickly? Ctrl+a and Ctrl+a.
Do you want to remap Ctrl+a to another key, say Ctrl+b? Just put escape ^b in your .screenrc.
