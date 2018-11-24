---
author: Florent
date: 2010-11-21 15:19:46+00:00
draft: false
title: Tunalysis - analyse your iTunes music library
type: post
url: /blog/2010/tunalysis-analyse-your-itunes-music-library/
categories:
- OS X
tags:
- itunes
- ruby
- tunalysis
---

[![Tuna](http://farm5.static.flickr.com/4089/5194622027_6667b6d372.jpg)
](http://www.flickr.com/photos/pluies/5194622027/)

Tunalysis is a small(ish) Ruby script that will read your iTunes library, crunch numbers, and gives you a few interesting facts about it, such as:



  * Total number of songs
  * Total number of playlists
  * Average song length
  * Average bitrate
  * Average play count
  * Average skip count
  * Total time spent listening to music


Some of these statistics are already available in iTunes, but Tunalysis ultimate goal is to expand iTunes (limited) stats and to give you hindsight on your musical habits and tastes.



## Tech



Tunalysis is written in Ruby and uses [Bleything's plist](https://github.com/bleything/plist) to parse iTunes' XML library.

At the time being, Tunalysis only works on OS X. I'm not planning to do a Windows port, but will gladly accept a patch if you do. :)

Tunalysis is licensed under the GPLv3.



## Features to come





  * You don't like that: suggest music to delete based on the skip count, the play count, and the last played date
  * Preferred artists (by number of songs)


I'm open to suggestions. If you're interested in a particular piece of data, leave a comment or send me an email and I'll add it.

Get [Tunalysis on GitHub](http://github.com/Pluies/Tunalysis)!
