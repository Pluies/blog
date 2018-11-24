---
author: Florent
date: 2010-03-23 00:29:28+00:00
draft: false
title: Seitunes, an iTunes command-line interface
type: post
url: /blog/2010/seitunes-an-itunes-command-line-interface/
categories:
- OS X
tags:
- curses
- itunes
- OS X
- Seitunes
---

My home main computer is a MacBook Pro, on which I frequently play music with iTunes. However, I'm often on my laptop, without direct access to the MBP's screen or keyboard/mouse to pause, change song, change volume, etc. I can connect to the MBP using VNC, but I was looking for something more lightweight.

I therefore decided to design a command-line interface for iTunes, that I would run via SSH. I called it Seitunes for reasons I can't really remember right now, but there it is!


## Seitunes is


- written in C and interfaces with iTunes through AppleScript
- designed for OS X - should be compatible with quite old versions actually, because it doesn't rely on a lot of cutting edge features
- built upon the [curses](http://en.wikipedia.org/wiki/Curses_%28programming_library%29) library
- very very small
- still under development
- Free software (GPLv3)
- available [here](http://github.com/Pluies/Seitunes)


## Features


> Display iTunes playing track and status

[![Seitunes main screen](/blog/wp-content/uploads/2010/03/Seitunes1.png)
](/blog/wp-content/uploads/2010/03/Seitunes1.png)

> Control iTunes playback (play/pause, volume, next song/previous song)

[![Seitunes, main screen, playing, with help](/blog/wp-content/uploads/2010/03/Seitunes2.png)
](/blog/wp-content/uploads/2010/03/Seitunes2.png)

> If iTunes is stopped when Seitunes starts, it starts iTunes and starts a song from the Library.


## To do


> Add more tests to better check iTunes state and not trigger Applescript errors
> Add info about playlists in order to be able to play a specific playlist instead of the whole library
> Add an option to toggle shuffle
> Implement the "quit iTunes" function and check that it doesn't cause more Applescript problems


## Known bugs


> An error message flickers when an Applescript error is triggered (often when iTunes quit while Seitunes is opened)
