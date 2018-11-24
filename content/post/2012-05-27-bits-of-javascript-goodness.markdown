---
author: Florent
date: 2012-05-27 05:14:26+00:00
draft: false
title: Bits of javascript goodness
type: post
url: /blog/2012/bits-of-javascript-goodness/
categories:
- Programming
tags:
- javascript
---

(This blog post is better followed with [the associated github repo](https://github.com/Pluies/Bits-and-pieces/tree/master/JSBlogPost-May2012). Run the Sinatra server with 'ruby slowserver', pop up a browser, and follow the revisions to see how the code gradually gets better. :) )

Recently at work, we wanted to modify some js ad code to include weather data for better ad targeting. For certain caching reasons, weather data has to be fetched by an AJAX call, then fed to the ad code.

The existing ad code was (schematically) [as follows](https://github.com/Pluies/Bits-and-pieces/blob/28dc08ef21cde9dd854f2b2a0a79b1775034420a/JSBlogPost-May2012/index.html).

My first idea was to replace those calls by a call to a single js method, which would stall the ad calls using, say, a setTimeout, until the weather data is retrieved. The js looked [like this](https://github.com/Pluies/Bits-and-pieces/blob/450ba36613fd904852e26c1fe9048608f062a712/JSBlogPost-May2012/public/patience.js).

Before you go get the pitchforks, I knew that this code was crap, and asked one of my amazing colleagues for help. He advised me to get rid of the timeOuts and instead use a function that would either, depending if the data was retrieved or not, shelf the task in an array, or execute it.

Using an array of tasks (actually callbacks, or anonymous functions, or closures) allows us to have actual event-driven javascript. This means executing the ad loading code only once, not using resources for timeouts when the resource is not available yet, and maybe most importantly not looking stupid when code review time codes.

Additionally, my code littered the general namespace with his variables. We could instead create a module, and have only that module's name public - we clean up the global namespace and also get private variables for free!
The module pattern is an amazingly useful javascript pattern, implemented as a self-executing anonymous function. If that sounds clear as mud, Ben Cherry has a better, in-depth explanation [on his blog](http://www.adequatelygood.com/2010/3/JavaScript-Module-Pattern-In-Depth).

The js code now looked [like this](https://github.com/Pluies/Bits-and-pieces/blob/9edd3e3524cf56ca3206d18d959ca1e2ca053c2f/JSBlogPost-May2012/public/patience.js).

But the HTML still contained `<script>` tags, and separation of concerns taught us it's better to keep HTML and JS as separate as possible. Cool beans, let's just add a couple of line [to our js file](https://github.com/Pluies/Bits-and-pieces/blob/8d1d9644739015a4cbde28e2f79a9d9a728fdea0/JSBlogPost-May2012/public/patience.js).

Result: a pure event-driven wait for a callback, a single variable in the global js namespace, and a cleaned-up HTML.

And of course... We ended up not using it. The ad code actually expects a document.write, making this delayed approach impossible (document.write appends data inline while the page is still loading, but completely rewrites the page if called after pageload). Good learning experience still!
