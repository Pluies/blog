---
author: Florent
date: 2011-01-26 14:19:08+00:00
draft: false
title: Can't find the PostgreSQL client library (libpq)
type: post
url: /blog/2011/cant-find-the-postgresql-client-library-libpq/
categories:
- OS X
---

You might encounter this error while trying to install the pg gem (v0.10.1), or when updating from v0.10.

My stacktrace on Mac OS X Snow Leopard 10.6.6 with Rubygems 1.4.2, Ruby 1.8.7 and Postgres 9.0.2 was the following:

    
    Building native extensions.  This could take a while...
    ERROR:  Error installing pg:
    	ERROR: Failed to build gem native extension.
    
    /System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/bin/ruby extconf.rb
    checking for pg_config... yes
    Using config values from /usr/local/bin/pg_config
    checking for libpq-fe.h... yes
    checking for libpq/libpq-fs.h... yes
    checking for PQconnectdb() in -lpq... no
    checking for PQconnectdb() in -llibpq... no
    checking for PQconnectdb() in -lms/libpq... no
    Can't find the PostgreSQL client library (libpq)
    *** extconf.rb failed ***
    Could not create Makefile due to some reason, probably lack of
    necessary libraries and/or headers.  Check the mkmf.log file for more
    details.  You may need configuration options.



Oookay, so let's try to find out what's going wrong. A quick Google search shows that errors like this one happens on Linux too, and usually suggests that ARCHFLAGS definitions may be a problem. Indeed, /Library/Ruby/Gems/1.8/gems/pg-0.10.1/ext/mkmf.log contains this error message:

    
    ld: warning: in /usr/local/Cellar/postgresql/9.0.2/lib/libpq.dylib, file was built for unsupported file format which is not the architecture being linked (i386)



The problem seems to come from the way [Homebrew](https://github.com/mxcl/homebrew) installs Postgres.

Homebrew install notes include the following informative message:

    
    If you want to install the postgres gem, including ARCHFLAGS is recommended:
        env ARCHFLAGS="-arch x86_64" gem install pg



There! Now the only problem is if you install your gems as root, you can't merely put a sudo before the "gem", but you have to sudo su then execute the command:

    
    Air:~ florent$ sudo su
    Password:
    sh-3.2# env ARCHFLAGS="-arch x86_64" gem install pg
    Building native extensions.  This could take a while...
    Successfully installed pg-0.10.1
    1 gem installed
    Installing ri documentation for pg-0.10.1...
    Installing RDoc documentation for pg-0.10.1...



Voilà!

**Edit 18 Dec.** Chad provided a simpler solution in the comments that doesn't require you to log in as root and works just as well:

    
    sudo env ARCHFLAGS="-arch x86_64" gem install pg
