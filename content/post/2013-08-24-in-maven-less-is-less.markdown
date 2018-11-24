---
author: Florent
date: 2013-08-24 03:51:50+00:00
draft: false
title: In Maven, LESS is less
type: post
url: /blog/2013/in-maven-less-is-less/
categories:
- Programming
tags:
- java
- less
- maven
---

Sorry, this is a rant.

I was recently investigating Maven plugins for LESS compilation. The use-case is pretty run-of-the-mill (I think?): I want to be able to write a .less file anywhere in my project _src/_ folder and have Maven compile it to CSS in the corresponding folder in _target/_ at some point of the build pipeline.

I first looked into [lesscss-maven-plugin](https://github.com/marceloverdijk/lesscss-maven-plugin), a short-and-sweet kind of tool that looks perfect if you have one (and *only one*) target folder for all of your CSS. Working on a large project including things such as separate templates and per-plugin CSS, this would not be working for us.

More reading and research lead me to [Wro4j](http://code.google.com/p/wro4j/wiki/MavenPlugin), Web Resources Optimization for Java. One understood the cryptic acronym, it sounds like the kind of all-encompassing tool that the Gods of Bandwidth and Simplicity would bestow upon us mere mortals provided we made the required server sacrifices. A noble idea, but after actually using the thing, it didn't take me long to drop the religious metaphor.

Wro4j is a horrible mess. There's absolutely no justification in any way, shape or form for the complexity involved in this plugin. As a perfect example of being too clever for its own good, Wro4j includes several parsers for the configuration file: an XML parser, a JSON parser, and for some reason a Groovy parser. Why you would need three different ways to configure a poor Maven plugin âwhich _should_ get its configuration from the pom.xml anywayâ is beyond me.
And the implementation is the most horrific part: when supplied with a config file, Wro4j will try all successive parsers (yes, **even when the file extension is .xml**(1)) on the file and end up with this absolutely undecipherable error message if parsing failed with each 'Factory'. Which will happen when Wro4j doesn't like your XML configuration file for some reason.

I ended up using a bash script to find .less files and call lessc on them. No it's not portable, no it's not "the maven way", but at least it works and it's maintainable.



1: it takes a special kind of crazy YAGNI-oblivious Java helicopter architect to consider that a Groovy file saved as 'config.json' should be a supported feature. In a **Maven** (which is so heavily XML-based) plugin of all places!
