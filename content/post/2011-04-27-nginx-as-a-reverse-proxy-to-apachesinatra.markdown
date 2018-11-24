---
author: Florent
date: 2011-04-27 22:12:20+00:00
draft: false
title: nginx as a reverse-proxy to Apache+Sinatra
type: post
url: /blog/2011/nginx-as-a-reverse-proxy-to-apachesinatra/
categories:
- OS X
tags:
- apache
- nginx
- sinatra
---

I was recently developing a Sinatra app that wanted to host from home â setting it up Heroku would have meant migrating from SQLite to Postgres, and I'm lazy. The problem was that I already happened to have an Apache server at home to serve some other content, specifically some calendars through the WebDAV module.

The solution I used was simple: instead of having Apache listening on port 80, I set up nginx to listen to port 80 and redirect to either Apache (set to listen on port 8080 instead) or Sinatra (port 9393) depending on the URL.



Nginx configuration was dead simple (after a few tries). The gist of it being these few lines:

    
    location / {
        proxy_pass http://127.0.0.1:8080/;
    }
    location /reorg {
        proxy_pass http://127.0.0.1:9393;
    }


The configuration in its entirety is available [here](/blog/wp-content/uploads/2011/04/nginx.conf_.txt).



After setting up this solution, I realized Apache's mod_proxy would have done the trick without the need for nginx. And that mod_rack (Phusion Passenger) could probably have eliminated the need for running a specific ruby process for Sinatra at all. Live and learn!
