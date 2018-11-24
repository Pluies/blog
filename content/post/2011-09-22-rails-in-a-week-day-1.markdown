---
author: Florent
date: 2011-09-22 20:06:42+00:00
draft: false
title: "Rails in a week - day 1"
type: post
url: /blog/2011/rails-in-a-week-day-1/
categories:
- Programming
tags:
- rails
- railsinaweek
---

TL;DR: I began learning Rails this morning, and even though Rails in itself is (seems?) easy enough, setting everything up and deploying is hairier.



**8:00**: let's get started! First step: getting vagrant up and running. We'll hit the [tutorial](http://vagrantup.com/docs/getting-started/index.html).
**8:15**: the lucid32 "box", Vagrant's parlance for a virtual machine image, is downloading. Time to get a cup of coffee.
**8:40**: box downloaded, let's get on with the VM setup process. `vagrant ssh`... Yep, it works!
**8:50**: adding a few cookbooks. The Vagrantfile syntax (which is actually Ruby) isn't recognized by vim; to fix that later.
**9:00**: first oops of the day:


<blockquote>[09:00:38] florent@Air:~ $ vagrant reload
[default] Attempting graceful shutdown of linux...
[default] Clearing any previously set forwarded ports...
[default] Forwarding ports...
[default] -- ssh: 22 => 2222 (adapter 1)
[default] Cleaning previously set shared folders...
[default] Creating shared folders metadata...
[default] Running any VM customizations...
[default] Booting VM...
[default] Waiting for VM to boot. This can take a few minutes.

[default] Failed to connect to VM!
Failed to connect to VM via SSH. Please verify the VM successfully booted
by looking at the VirtualBox GUI.
[09:06:25] florent@Air:~ $</blockquote>


The VirtualBox GUI shows the VM running, but nothing more. Can't force restarting the VM (or even stop it) from the GUI. Let's start over: kill the VM process, vagrant destroy; vagrant up

Same error. Uh-oh. Is it because of the cookbooks I added? Let's try deleting them and reverting to the original Vagrantfile. No luck.

Alright! Google to the rescue! And there we go, a [Stack Overflow discussion](http://stackoverflow.com/questions/4681070/vagrant-ssh-fails-with-virtualbox) leading to a [bug report on GitHub](https://github.com/mitchellh/vagrant/issues/391). Well known network-related issue then, a fix seems to start the machine with GUI enabled and `/etc/init.d/networking restart` so that vagrant can SSH into the VM. Not ideal, but meh. Let's advance!
**9:45**: phew! That took some time. Now let's add back those cookbooks.
**9:55**: added to the Vagrantfile, the cookbooks install themselves.
**10:00**: port forwarding works, now's time to go buy groceries while downloading a [Debian Box](http://www.vagrantbox.es/4/) for later.

--

**13:45**: back! Stomach full and coffee by my side.
**14:30**: that whole Vagrant/Chef thing is a bit strange. There seem to be a recipe for Rails on Opscode's (the company behind Chef) GitHub account, but it seems to also installs a bunch of Java stuff. Anyway... We'll get to the bottom of provisioning later, the goals here is to learn Rails, right? Let's just install what's needed by hand.
**15:00**: new Debian Vagrant box set up. Installing rvm to get ruby 1.9.2.
**15:20**: `rvm install 1.9.2` then `rvm use 1.9.2`: Ruby all set. Good.
**15:22**: `gem install rails` let's go!

(Starting Rails for Zombies on the side)
Lesson 1: okay, so there's a built-in ORM in Rails. That seems to be ActiveRecord if I understand correctly. Gives you methods like Tweets.find(id), etc.
Lesson 2: models. Models are the O in ORM, and the M in MVC.
Lesson 3: erb. Built-in templating. The V in MVC.
Lesson 4: controllers. The C in MVC.
Lesson 5: routes. The mapping between URLs and actual code.

**17:00**: alright! Rails for Zombies is done, I feel ready to start a real Rails project.
`rails new sample`
Bunch of stuff getting created... All done. Let's launch!
`cd sample && scripts/rails server` ... Crashes. Says it needs a Javascript runtime. Why? No idea. But [here's the fix](http://stackoverflow.com/questions/6282307/rails-3-1-execjs-and-could-not-find-a-javascript-runtime).
"Still pretty lame that rails 3.1 is "broken" out of the box.", says wonderfulthunk. Quite true. :|

**17:20**: gem added, bundler works (`bundle install` manages dependencies and puts the needed gem into the "/vendor" folder), `script/rails server` works! Let's plug the host's port 3000 to the VM's one and set up a shared folder so that we can develop and test from the host machine while running everything in the VM. This is all done in the Vagrantfile.
**17:30**: setting up the shared folder ate the Rails project. Fun times. Re-create it, re-add the gem, re-bundle, re-start the server...
**17:40**: it works! I can see Rails' welcome page.
**17:41**: so, what now? "1. Use rails generate to create your models and controllers" Okay, sure.
Let's try and create something simple, say a blog. It need posts. `script/rails generate model post`: it creates the model I want, some migration (?) stuff and some testing stuff. But wait, it doesn't create any view, or controller... There is a better way: scaffold. `script/rails generate scaffold` gives us an example of how the command works, by suggesting to create... A blog post. Great minds think alike, I guess. ;D [/narcissism]
Scaffolding creates another bunch of stuff. Looking at config/routes.rb, there is now a resources :posts. So I guess going to http://localhost:3000/posts should work?
=> _Could not find table 'posts'._ Oh.
Let's see what's in the db then. I remember an option on the rails script about that: yep, `script/rails db`
It gives an SQLite shell:


<blockquote>sqlite> show tables;
Error: unable to open database "db/development.sqlite3": unable to open database file</blockquote>


Ah! So there's no database. Time to learn a bit more about that migration stuff.
**18:15**: So I checked the official [Getting Started](http://guides.rubyonrails.org/getting_started.html) guide on RubyonRails.org, recommended [by orta on HN](http://news.ycombinator.com/item?id=3023976), and it's really well written and comprehensive. I should have started here actually; it's exactly the right amount of conciseness and straightforwardness. That'll teach me not listening to others.
The database is created with `rake db:migrate`.
**18:20**: http://localhost:3000/posts is now a fully functioning CRUD app. Is it supposed to be that easy? It really feels like cheating.
The example on the aforementioned Getting Started guide is a blog, so I'll piggy-back on it for the rest of the day.
**20:00**: hmm. Learned about automatic code generation, configuration over convention (it's all automatic! The error messages look like they might be a bit cryptic from time to time, though), migrations, and partials. Lots of nifty features indeed. And all is _quite_ simple. So simple that I'm actually going to try and quickly write that antipodes application tomorrow, then practice TDD and stop worrying about deploying before I actually have an app to deploy.



On a side note, yesterday's "day 0" post has been viewed nearly 1200 times thanks to a (brief) appearance on HN's front page. That helps building up some pressure, I hope not to disappoint. :)



Come back tomorrow for more bug-fighting, stumbling in the dark and unstructured write-ups!
