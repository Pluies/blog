---
author: Florent
date: 2011-10-02 20:46:58+00:00
draft: false
title: "Rails in a week - day 7"
type: post
url: /blog/2011/rails-in-a-week-day-7/
categories:
- Programming
tags:
- rails
- railsinaweek
---

Today was the last day of my Rails week. I added some database-backing to my app (with a fully scaffolded model and all!) for the countries' data and refactored a fair bit, though I'm still unsure about a few decisions I made, such as if I should put the base data in seeds.rb or in a migration. Oh, well.

The website is available here:

[http://antipodes.plui.es](http://antipodes.plui.es)

And its source code [is on GitHub](https://github.com/Pluies/Antipodes).


## So?


Writing this website taught me quite a lot about Rails in general, from its innards to automated deployment. I still have a lot to learn, and more importantly a lot of practice to do before I can say I'm competent with Rails, but that was a great start. *self-pat on the back*

The more important thing to me is that even though I didn't have the time to learn each of the aspects of the Rails ecosystem inside and out, I have a better overview of "what does what" in Rails, and a lot of good pointers to learn more when needed.


## Buzzword bingo!


All in all, I learned ("began learning" would be more appropriate):



	  * Vagrant, and a tiny bit of Chef
	  * Rails (eh!): MVC, migrations, the global directory structure, views/partials, the asset pipeline, etc.
	  * RVM
	  * Bundler
	  * Rake
	  * Spork
	  * Autotest
	  * RSpec
	  * Capistrano



## Loose ends


Well, although I think I understood a fair amount of what I set out to learn, I still don't grasp Chef at all, and didn't really adhere to the philosophy of TDD through the week. My tests are really basic and not very satisfying; writing meaningful tests seems like quite an difficult art that I'll have to learn more about.

Another thing that bugs me a bit is that it took more time than I originally thought to do a lot of the things I set out to do. This is probably due to inexperience, so in a way I'm curing it? I guess? I probably could have gained some time by asking a few questions on things like IRC, but it felt a bit stupid when there's such a trove of information about Rails online. Indeed, googling and reading guides or StackOverflow threads / mail threads always ended up giving the answer; but maybe not as fast as IRC would've been.

Oh, and the design of the website is pretty terrible, but that wasn't really the goal (and CSS has never been my forte).


## What now?


Well, as far as Rails go, I'm ready to tackle bigger things. I hope to find a Rails job in Wellington (wink wink nudge nudge if you're reading this from New Zealand ;) ) and put this freshly-acquired knowledge to good use!

I also hope these blog posts might help a newcomer to Rails, but they ended up being half ranting and half specific bug-finding, so I'm not sure of their value as a learning tool. Or as a read to anyone else than me actually. I'll just post this on HN and let the crowd decide.
