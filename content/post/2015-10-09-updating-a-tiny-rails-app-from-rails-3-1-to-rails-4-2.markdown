---
author: Florent
date: 2015-10-09 01:54:18+00:00
draft: false
title: Updating a tiny Rails app from Rails 3.1 to Rails 4.2
type: post
url: /blog/2015/updating-a-tiny-rails-app-from-rails-3-1-to-rails-4-2/
categories:
- Programming
tags:
- rails
- ruby
- upgrade
---

In 2011 I wrote a small Rails app in order to learn Ruby better and see what all the fuss was about â this was [Antipodes](https://github.com/Pluies/Antipodes/), a website that shows you the antipodes of a given point or country/state using google maps.

I built it using the latest and greatest version of Rails available at the time, which was 3.2. It has since fell to various security issues and has been superseded by newest version, and is currently unsupported.

I've been aware of these limitations and decided not to carry on hosting on such an old version, so I just stopped the nginx instance that was powering it and left it aside.

Until now! I had some time to spare recently, so I decided to upgrade.


## Updating to Rails 3.2


The [railsguide](http://edgeguides.rubyonrails.org/upgrading_ruby_on_rails.html) documentation about upgrading suggests not to update straight to the latest version of Rails, but to do it by steps instead. The first one for me was to update from 3.1 to 3.2.

First up, let's [update our Gemfile](https://github.com/Pluies/Antipodes/commit/05b7477567864a603fce0b21d68cac72baad2502) to pick up on the new Rails version, and let's dive in!

The first issue I ran into was that the `:timestamps` model field definition are now marked as `NON NULL`. I wasn't actively using these, so [I decided to remove them](https://github.com/Pluies/Antipodes/commit/c831e30a63a0036e0ac6d91549c9a6c32e8905b7) from the DB rather than fixing DB import code.

My next issue was that some gems would not install properly - I decided to use the newest version of Ruby available on the system, 2.2, and it was not happy at my Gemfile requiring `ruby-debug19`. [Fair enough, let's remove it](https://github.com/Pluies/Antipodes/commit/274e5d79412eefe14298f9abefd99454a485761a).

My next problem didn't come from Rails itself, but rather from the gem I used to generate Google Maps, Gmaps4Rails. It underwent a serious rewrite in the past 4 years and now needed very different code under the hood - [no problem](https://github.com/Pluies/Antipodes/commit/8fe357c2a7d9d578ef5c3a1771aa494ed71641c8). It also allowed me to clean some of the .coffee files and make better use of the assets pipeline.

An lo, the website was running under Rails 3.2!


## Upgrading to Rails 4.0


The next step was to [upgrade to Rails 4.0](https://github.com/Pluies/Antipodes/commit/930ba2adbdedf80beb2b487f7c32e2e19eb3c245). This was very straightforward, a quick change in the Gemfile and a change to route handling (`match` was retired in favour of using the actual HTTP verbs of the route being handled, e.g. `get`) made it work, and a couple of new config options silenced the deprecation warnings.


## Upgrading to Rails 4.2


And finally, the [upgrade from Rails 4.0 to Rails 4.2](https://github.com/Pluies/Antipodes/commit/9220ede82aefb001cbf9232689b41c10d55a7b59) was made through the Gemfile only, no update was needed on the code itself.



And here we are! Antipodes is now up to date with its dependencies, and waiting for a new nginx+passenger to run again (more on that soon!).
