---
author: Florent
date: 2011-09-29 21:39:28+00:00
draft: false
title: "Rails in a week - day 5"
type: post
url: /blog/2011/rails-in-a-week-day-5/
categories:
- Programming
tags:
- rails
- railsinaweek
---

TL;DR: polishing. Trying to get into TDD, but slowness makes it a strange experience.

This "day 5" has been more or less spread over two days because of other engagements (mowing the lawn and subscribing an insurance policy for abroad if you wish to know the details), and I didn't keep precise tracks of the steps I took.

The major milestone is that the MVP for Antipodes is online at [http://antipodes.plui.es](http://antipodes.plui.es) (and has [its own repo on GitHub](https://github.com/Pluies/Antipodes)). I threw away all of the first rails project and restarted from a clean slate, then roughly followed the same steps again (Bundler, Capistrano, etc) and added back the logic. I also polished the whole thing: instead of manually entering the request in the URL (eh, it was a prototype...), there's a form and everything. There's even a purdy logo!

Back to some more Rails-y stuff: I tried to start working on some Test-Driven Development, but at over 30 seconds per test round _with a single assert true_, I couldn't really get into any sort of good flow. autotest manages to run the tests in around 20 seconds (and more importantly in the background), but it's still way too much. I just noticed that Spork might be a good solution, I will try it tomorrow.

Once the tests are automated and fast enough, I will start bugfixing (for example right now an empty chain results in a 500 error) and adding another new functionality: whole countries!
