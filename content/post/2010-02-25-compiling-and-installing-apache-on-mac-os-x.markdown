---
author: Florent
date: 2010-02-25 00:52:57+00:00
draft: false
title: Compiling and installing Apache on Mac OS X
type: post
url: /blog/2010/compiling-and-installing-apache-on-mac-os-x/
categories:
- OS X
tags:
- apache
- OS X
---

**Update**: instead of the completely manual method, I'd now recommend using the most excellent [Homebrew](https://github.com/mxcl/homebrew). The "missing package manager for OS X" will automatically download and compile the latest version and verify the checksums, amongst other niceties. It's awesome, and only gaining more momentum.
  

  

  

**Original post**:

As you may already know, Apple bundles a version of Apache into Mac OS X. This httpd can be started in System Preferences > Sharing > Web Sharing. Its configuration files are located in /etc/apache2/.

Unfortunately, given Apple's habit of not releasing patches too often, OS X's Apache might lag a few versions behind. For example, bundled version on Snow Leopard at the time I'm writing this is 2.2.13; while the latest version is 2.2.15. It contains some (small to medium-ish depending on your setup) security fixes.

Hence, here I'm going to speak about building and installing your own Apache on OS X.

First, let's get our hands on the sources: [download the latest version](http://httpd.apache.org/download.cgi) from the Apache Foundation. Save it somewhere and check the integrity of the archive using MD5:

    
    mbp:~ florent$ md5 ~/Downloads/httpd-2.2.15.tar.bz2
    MD5 (/Users/florent/Downloads/httpd-2.2.15.tar.bz2) = 016cec97337eccead2aad6a7c27f2e14


Or SHA1:

    
    mbp:~ florent$ shasum ~/Downloads/httpd-2.2.15.tar.bz2
    5f0e973839ed2e38a4d03adba109ef5ce3381bc2  /Users/florent/Downloads/httpd-2.2.15.tar.bz2


These computed hashes should match the values given on the Apache website1.

Now time to configure our httpd.

Untar the archive, `cd` into the installation folder, and:

    
    mbp:httpd-2.2.15 florent $ ./configure --prefix=/my/path


Here, the prefix we choose is the folder where apache will be installed. By default, it is set to /usr/local/apache2.

Now we just have to build and install Apache:

    
    mbp:httpd-2.2.15 florent$ make && sudo make install


All set!

You can use apachectl to start the newly installed server:

    
    mbp:~ florent$ sudo /usr/local/apache2/bin/apachectl start


1. If they don't, you have quite a big problem: try downloading the archive again. If still no match, you may be the victim of a Man in the Middle attack; but a sloppy one (if you're being tricked into downloading a fake archive, the attacker should be able to send you fake hashes too). Or more probably an infected mirror. Or even more probably you're not reading the right hashes on the Apache website. : )
