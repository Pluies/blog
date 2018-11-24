---
author: Florent
date: 2009-10-03 16:07:52+00:00
draft: false
title: A Keynote update is available. Would you like to open Software Update?
type: post
url: /blog/2009/a-keynote-update-is-available-would-you-like-to-open-software-update/
categories:
- OS X
tags:
- keynote
- OS X
---

This nice explicative window popped up last time I opened Keynote (iWork '09) :


![A Keynote update is available. Would you like to open Software Update ?](/blog/wp-content/uploads/2009/10/Keynote-upgrade.png)



Why yes, I would love to, but when I open Software Update...


![Your software is up to date.](/blog/wp-content/uploads/2009/10/Keynote-upgrade-2.png)



No updates are available.

What's happening there ? Well, it seems that OS X's Software Update only checks for /Applications/ to see if Apple applications (e.g. iWork, Aperture) are present on the system, and need upgrading. Which means that if you have some of these Apple applications located at any other place on your hard drive -in my case, being a subfolder-creating control freak, /Applications/Work/iWork '09/Keynote.app -, they won't update properly.

Easy fix? Put the iWork '09 directory back into /Applications/, let Software Update do its job, and then reorganize your directories as you like. You will have to do it for each new update though.
