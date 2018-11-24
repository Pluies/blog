---
author: Florent
date: 2010-06-12 22:36:11+00:00
draft: false
title: Photocard - a Java postcard generator
type: post
url: /blog/2010/photocard-a-java-postcard-generator/
tags:
- java
- linux
---

As a school project, we recently finished Photocard, a Java application for Linux that allows you to design postcards ('we' as in a couple of other students & me).

Basically, Photocard listens to /media/ for an USB key, lets you chose a blueprint for your card (that might contain text and pictures), then drag and drop pictures into that blueprint, retouch them, and print your card (actually save it to /tmp/).

This is not a commercial-grade product, of course, and there are a lot of details I would have changed and improved, given some more time. For example, rotating pictures is choppy, luminosity and contrast aren't well defined, the notification system is botched, the XML parser seems way too complicated for what it does, the user interface could be improved... And we used the MVC pattern as good as we can, but I don't think we respect it fully.

However, it works! I'm pretty proud we managed to get it done on time. And some bits of it are really cool and pushed me to think about OO concepts in depth (anonymous classes & reflection in particular).

The project itself might be useful to someone out there, so we released it on Sourceforge under the GPL. All the comments (and the application itself) are in French, though.

Have fun!

[http://sourceforge.net/projects/photocardcpe/](http://sourceforge.net/projects/photocardcpe/)
