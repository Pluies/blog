---
author: Florent
date: 2010-05-03 22:51:20+00:00
draft: false
title: Fix ncurses in OS X 10.6.3
type: post
url: /blog/2010/fix-ncurses-in-os-x-10-6-3/
categories:
- OS X
tags:
- curses
- OS X
---

In response to my [blog post about the issue affecting arrows under OS X 10.6.3](/blog/2010/os-x-10-6-3-broke-ncurses/), Jonathan Groll pointed out that copying the ncurses libraries from an old 10.6.2 install would fix the problems. It works, but manipulating libraries in that way still feels a bit wrong to me.

And that's without even mentioning the security implications of getting these libraries from "somewhere on the internet" if you don't have them laying around anymore.

Instead, let's fix an Open Source system in the way Open Source is supposed to work: grab the sources and recompile!



# Grabbing the sources



Apple provides the sources for the insides of OS X on [opensource.apple.com](http://opensource.apple.com). Considering ncurses-31 (the [10.6.3 version](http://opensource.apple.com/release/mac-os-x-1063/)) is buggy, we'll download a tarball of ncurses-27 (the [10.6.2 version](http://opensource.apple.com/release/mac-os-x-1062/)) from Apple right there: [ncurses-27.tar.gz](http://opensource.apple.com/tarballs/ncurses/ncurses-27.tar.gz).



# Recompiling



Step 1: compile.


    
    mbp:ncurses-27 florent$ make



Step 2: install.


    
    mbp:ncurses-27 florent$ sudo make install
    Password:
    TargetConfig: MacOSX
    cd /tmp/ncurses/Build && CFLAGS="-arch x86_64 -arch i386 -arch ppc -g -Os -pipe -isysroot /" CCFLAGS="-arch x86_64 -arch i386 -arch ppc -g -Os -pipe " CXXFLAGS="-arch x86_64 -arch i386 -arch ppc -g -Os -pipe " LDFLAGS="-arch x86_64 -arch i386 -arch ppc            "  /tmp/ncurses/Sources/ncurses/configure \
    		--prefix=/usr --disable-dependency-tracking --disable-mixed-case \
    		--with-shared --without-normal --without-debug --enable-termcap --enable-widec --with-abi-version=5.4 --without-cxx-binding --without-cxx --mandir=/usr/share/man
    /bin/sh: line 0: cd: /tmp/ncurses/Build: No such file or directory
    make: *** [install] Error 1



Oookay, by default this Makefile tries to install ncurses into /tmp/ncurses and complains because the directory doesn't exist. Why not. There **has to be** an option to change that when calling make, but I went for the fastest choice:

    
    mbp:ncurses-27 florent$ mkdir /tmp/ncurses/Build
    mbp:ncurses-27 florent$ sudo make install



And wait for the magic to happen. It's quite long (and verbose) actually, don't worry if it takes a few minutes.

Once this was finished, I launched sudo update_dyld_shared_cache and ran some tests: no luck, ncurses still behaved badly.

Then I noticed the "make install" output seemed to show ncurses-27 was actually installed (great!)... In /tmp/ncurses (not so great).



# Making it (actually) work



I don't fully understand how OS X deals with these source tarballs. However, I noticed that /tmp/ncurses/Build contains a Makefile. It looks like what's installed in /tmp/ncurses is merely an intermediary build that you can then install:

    
    mbp:ncurses-27 florent$ cd /tmp/ncurses/Build/
    mbp:Build florent$ make
    mbp:Build florent$ sudo make install



I then ran sudo update_dyld_shared_cache again. This time, it prompted:

    
    update_dyld_shared_cache[62767] current i386 cache file invalid because /usr/lib/libncurses.5.4.dylib has changed
    update_dyld_shared_cache[62767] current x86_64 cache file invalid because /usr/lib/libncurses.5.4.dylib has changed


Which is good, because it shows we actually changed the compiled version of ncurses (libncurses.5.4)
  
  

I finally ran the tests again: ncurses now works like a charm!
