---
author: Florent
date: 2011-12-23 10:45:31+00:00
draft: false
title: Keep GimmeSomeTune running
type: post
url: /blog/2011/keep-gimmesometune-running/
categories:
- OS X
---

As a follow-up on my [previous post on the question](/blog/2011/automatically-restart-applications-on-os-x), which advocated a simple (but bad) approach to keeping GimmeSomeTune running, here's a better way!

The Good Thing (tm) to do is to use OS X's built-in mechanism to start and keep processes running, namely [launchd](http://en.wikipedia.org/wiki/Launchd).

What we have to do is simply to write a plist containing the info needed by launchd, namely:

    
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    	<dict>
    		<key>KeepAlive</key>
    		<true/>
    		<key>Label</key>
    		<string>at.eternalstorms.gstlauncherdaemon</string>
    		<key>ProgramArguments</key>
    		<array>
    			<string>/Applications/GimmeSomeTune.app/Contents/MacOS/GimmeSomeTune</string>
    		</array>
    		<key>RunAtLoad</key>
    		<true/>
    	</dict>
    </plist>


Save this as a plist file in ~/Library/LaunchAgents. The name doesn't really matter, but the best way to keep everything tidy and adhere to OS X's standards is to call it at.eternalstorms.gstlauncherdaemon.plist.

Alright! Now GimmeSomeTune is going to start when you log in, and launchd will make sure it keeps running (i.e. relaunch it if it crashes). To tell launchd to use that plist file right now without having to log out and back in again, run:

    
    launchctl load -w ~/Library/LaunchAgents/at.eternalstorms.gstlauncherdaemon.plist


And conversely, to stop it:

    
    launchctl unload -w ~/Library/LaunchAgents/at.eternalstorms.gstlauncherdaemon.plist
