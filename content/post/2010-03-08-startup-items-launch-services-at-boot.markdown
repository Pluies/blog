---
author: Florent
date: 2010-03-08 22:50:50+00:00
draft: false
title: 'Startup Items: launch services at boot'
type: post
url: /blog/2010/startup-items-launch-services-at-boot/
categories:
- OS X
tags:
- apache
- OS X
- startup items
---

This post is a follow-up on the [setup of your own Apache web server](/blog/2010/compiling-and-installing-apache-on-mac-os-x/) (although the technique can be used to start about anything of course).

Unlike classical Linuces that stock programs to launch at boot in a /etc/init.d folder for example; OS X uses a mechanism called Startup Items. These items can be found in /Library/StartupItems/, ~/Library/StartupItems and /System/Library/StartupItems.

One particular strength of the Startup Items is that you can specify in which order to launch them.

Let's say I'll make a startup item called _MyApache_. I'll start by create the folder:

mbp:~ florent$ sudo mkdir /Library/StartupItems/MyApache

This folder will contain at least two files: an executable script called _MyApache_, and a file called _StartupParameters.plist_.

The script will be called at startup and shutdown, and will look like this:

```sh
#!/bin/sh

## Apache Web Server ; custom install ##

. /etc/rc.common
StartService (){
    ConsoleMessage "Starting Apache"
    /usr/local/apache2/bin/launchctl start
}

StopService (){
    ConsoleMessage "Stopping Apache"
    /usr/local/apache2/bin/launchctl stop
}

RestartService (){
    ConsoleMessage "Restarting Apache"
    /usr/local/apache2/bin/launchctl restart
}

RunService "$1"
```

The _StartupParameters.plist_ file will contain data about the information to launch. It's an XML file that will look like:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Description</key>
    <string>My own Apache webserver</string>
    <key>Messages</key>
    <dict>
        <key>start</key>
        <string>Starting my Apache</string>
        <key>stop</key>
        <string>Stopping my Apache</string>
    </dict>
    <key>Preference</key>
    <string>Late</string>
    <key>Provides</key>
    <array>
        <string>MyApache</string>
    </array>
    <key>Requires</key>
    <array>
        <string>Network</string>
    </array>
    <key>Uses</key>
    <array>
        <string>Disks</string>
    </array>
</dict>
</plist>
```

We can see that Apache Requires the networks to be up, and will use Disks.


Let's imagine I want to launch my Apache after my Jabber server for some reason. I'll just create a StartupItem called "Jabber", the same way as we just did, then add the following line to MyApache's StartupParameters.plist "Requires" section:

    
                    <string>Jabber</string>


Now at startup, OS X will launch Jabber and wait until it's up and running before launching Apache.
