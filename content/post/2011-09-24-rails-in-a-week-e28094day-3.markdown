---
author: Florent
date: 2011-09-24 22:37:26+00:00
draft: false
title: "Rails in a week - day 3"
type: post
url: /blog/2011/rails-in-a-week-day-3/
categories:
- Programming
tags:
- rails
- railsinaweek
---

TL;DR: phew. Deployment is hard. Testing is slow.



Morning: off due to World Cup; watching of the match against New Zealand. :(

Afternoon: while playing a bit more with the prototype, I noticed the logic is actually broken and my way to calculate an antipode was actually broken. This came from the fact that the longitude and latitude coordinates aren't logically the same. Latitude divides the globe on its equator while longitude is arbitrarily positioned... I guess? It doesn't really make sense; considering it's a sphere, any division is arbitrary. Anyways, that's how the coordinates system work: to get to the other side of the globe, you just have to change the sign of the latitude, and either add or substract 180° to the longitude depending on whether it's negative or positive.

A foray into testing: I began investigating RSpec, who doesn't seem to work on my two pages (because of the custom routes ?). To add insult to injury, that's how long it takes to test one spec:


```
vagrant@vagrant-debian-squeeze:/rails/sample$ time bundle exec rspec spec/
F

Failures:

1) AntipodesOneController GET '/a/washington' should be successful
Failure/Error: get '/a/washington'
ActionController::RoutingError:
No route matches {:controller=>"antipodes_one", :action=>"/a/washington"}
# ./spec/controllers/antipodes_one_controller_spec.rb:7:in `block (3 levels) in <top (required)>'

Finished in 0.10063 seconds
1 example, 1 failure

Failed examples:

rspec ./spec/controllers/antipodes_one_controller_spec.rb:6 # AntipodesOneController GET '/a/washington' should be successful

real 0m26.167s
user 0m13.769s
sys 0m5.716s
```


I'll get back to that later then, and focus and deployment. And oh, wow.

I feel like I'm not learning Rails, but merely fighting my way through Builder and Capistrano, their total integration with Git, and the stupidly complex overhead introduced by developing on a VM. But after a day and a bit of a night of tinkering and googling four different successive Capistrano error messages, it looks like deployment to my VPS finally works! Although it still doesn't work; passenger gives a 403 forbidden error message. I hope to make some progress tomorrow...
