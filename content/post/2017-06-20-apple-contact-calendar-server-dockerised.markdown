---
author: Florent
date: 2017-06-20 20:25:30+00:00
draft: false
title: Apple Contact & Calendar Server - dockerised
type: post
url: /blog/2017/apple-contact-calendar-server-dockerised/
categories:
- Programming
- UNIX
---

I've been using Radicale as a contacts / calendar server (CardDAV / DalDAV) for some time now, and it worked flawlessly across macOS and Windows Phone for contacts and calendars.

However, I recently got an iPhone and synchronising calendars from Radicale just crashed the iPhone calendar app. It worked fine _some_ of the time, but most times it just crashed, which is not great.

Therefore, I went on the search for a better self-hosted calendaring server. Onwards! To the internets! Who promptly gave me a [list of great self-hosted calendaring software](https://github.com/Kickball/awesome-selfhosted#calendar-and-address-books).

Off that list, I tried to install Baikal, but the claimed Docker installation is broken by default: the container fails to build. The Dockerfile is pretty messy and complex, and as I'd rather not rely on PHP (it's probably not the best filter, but... you know... PHP1), I gave up on it and looked into CalendarServer instead.

[CalendarServer](https://www.calendarserver.org/) is an Apple open-source project providing calendar and contacts, written in Python under the Apache licence. The software is still regularly updated (the 9.1 release dates from last month), backed by a huge corporation, and from the looks of it should sync with iPhone and macOS pretty easily :)

Unfortunately, the docs are a bit sparse, but the install script was a great starting point to write up a Dockerfile. In the end, the whole Dockerfile is little more than _apt-get install_ing all the dependencies and running the setup script.

Pretty helpful: this container, thanks to the built-in scripts, embeds all its external dependencies and runs Postgres and memcached. As long as you mount the data folder as a volume, you're good to go with a completely contained calendar/contacts server that saves up to a single folder!

The server refuses to start as root though, which is a bit annoying given that Docker volumes cannot be edited by a non-root user... That is, unless you give that user a specific UID, and you make sure to give this UID ownership on the volume on the Docker host. A bit hacky, but works fine.

As an example of how to run it, here is the systemd unit file I use to run the server:



You'll have to create that /opt/ccs/data folder yourself, and also create the config and user list as described in [the QuickStart guide](https://github.com/apple/ccs-calendarserver#quickstart).

The [code is on GitHub](https://github.com/Pluies/ccs-calendarserver/commit/72cbb3804fd94b22188d134f7c8ae810046ba062), and the built container is available [on the Docker Hub](https://hub.docker.com/r/pluies/ccs-calendarserver/).

Sync with iPhone and macOS has been absolutely faultless so far, so I'm pretty happy with it!





1: slightly ironic given this blog is Wordpress, but nvm.
