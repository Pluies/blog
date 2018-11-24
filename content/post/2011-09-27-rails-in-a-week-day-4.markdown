---
author: Florent
date: 2011-09-27 21:52:21+00:00
draft: false
title: "Rails in a week - day 4"
type: post
url: /blog/2011/rails-in-a-week-day-4/
categories:
- Programming
tags:
- rails
- railsinaweek
---

TL;DR: it deploys! Finally!



After a full day spend battling cryptic error messages, I finally got my 10-lines Rails app to deploy.

First thing in the morning, I decided to switch to using rvm on my production machine too, in order to have the same setup and version on Ruby (1.9.2) for testing and production. This meant also reinstalling the important gems (bundler, rails, rake).

The production machine uses nginx+Passenger, which I reinstalled (following instructions [here](http://beginrescueend.com/integration/passenger/)) in order to work smoothly with this now rvm-ed ruby.

The first problems I ran into were Capistrano issues. For some reason, the git repository for the rails project ([the one I also put on GitHub](https://github.com/Pluies/Rails-in-a-week)) wasn't the base rails folder, but merely contained all of rails under /sample/. Capistrano didn't like that at all: it relies on having the standard Rails architecture available at root level.

For example, in order to run bundler on the remote machine during deployment, Capistrano looks for the Gemfile and Gemfile.lock (_possibly_ only the Gemfile.lock) in the base folder of the git repo. My Gemfile wasn't in /Gemfile, but in /sample/Gemfile. A setting exists to tell Capistrano where to look for the Gemfile, but it then breaks in other subtle ways (notably during the migrations). I changed the structure so that all of the rails things appear at the root of the git repo (i.e. the Right Way), and Capistrano bundled gems like a champ.

Another problem was nginx configuration. In order to follow Capistrano's model, nginx 'server' directive must look something like:

    
    	server {
    		listen 80;
    		server_name (server name);
    		root /(capistrano's deploy_to in deploy.rb)/current/public/;
    		passenger_enabled on;
    	}


Yesterday night, it was set up at (capistrano's deploy_to)/current/sample/public/, because of the peculiar directory structure. That's what caused the 403 forbidden: Passenger had no idea what was there, because Capistrano couldn't understand it either and deploy correctly.

Once all of this was straightened up, I switched from nginx error messages to Passenger error messages, which was a good thing (getting closer to Rails!). The first few ones were gems that couldn't be found due to a missing lines in the Gemfile and commented out line in deploy.rb. Then, a notice that rake was missing despite it being included in the Gemfile and correctly bundled (_I saw it being bundled, I swear!_): it turned out that Bundler was using the production machine's ruby 1.8 to create his bundle when he should have been using rvm's 1.9.2. A few more lines in deploy.rb. The last error was that the database didn't exist. Indeed, when running a `cap deploy:update`, the whole directory was swiped out and replaced by the latest revision in Git, and Git excludes the database by default (which is sensible). `cap deploy:migrations` is the way to go to recreate you SQLite3 database in production.

After all of this, Capistrano seemed to deploy without any trouble, the gems were correctly bundled, and loading the app in a browser went to... Suspense... An error message. But a Rails one this time, which is still a Good Thing.

Going through nginx production logs showed this message:

    
    ActionView::Template::Error (gmaps4rails.css isn't precompiled):
    Â Â Â  1: <% #thanks to enable_css, user can avoid this css to be loaded
    Â Â Â  2: if enable_css == true and options[:scripts].nil? %>
    Â Â Â  3: Â Â  Â <% content_for :head do %>
    Â Â Â  4: Â Â  Â <%= stylesheet_link_tag 'gmaps4rails' %>
    Â Â Â  5: Â Â  Â <% end %>
    Â Â Â  6: <% end %>
    Â Â Â  7: <% content_for :scripts do %>
    Â  app/views/antipodes_one/show.html.erb:5:in `_app_views_antipodes_one_show_html_erb___4541095793564774527_30741960'


And here began my journey though the magical world of Rails 3.1 Brand New Asset Pipeline.

The asset pipeline is a great idea implemented in a weird way that breaks things. The more I learn about rails, the more it seems like that's the standard modus operandi of the community: move fast, don't worry if it breaks ancient stuff ("ancient" being loosely defined as "more than a year old"). The biggest problem of this approach is the constant learning it implies, and the fact that a _lot_ of the tutorials or workarounds you find with a quick googling will be out of date or broken. I guess that's the price to pay for the constant innovation going on in the Ruby world. Ah, well, software philosophy.

Anyways, Rails' new Asset Pipeline's job is to interpret, downsize and concatenate coffeescript and scss files into static files ready to be served â a step referred to as "precompilation" â in order to facilitate caching and reduce load times. Precompilation can either be done during deployment, e.g. as a Capistrano hook ("recipe" if I understand the lingo), or before deploying entirely, through a rake task: `RAILS_ENV=production bundle exec rake assets:precompile` â you'll then add those new files to source control and they'll be transferred during the standard Capistrano deploy phase. You can even skip the precompilation phase entirely and set a config switch in application.rb telling rails to compile the assets on-the-fly at runtime.

None of those options worked. gmaps4rails.css stubbornly stayed uncompiled.

After a fair amount of time being stuck on this issue (notably because each precompiling takes 30 seconds for a handful of files), I found an answer on StackOverflow: adding `config.assets.precompile += ['gmaps4rails.css']` in application.rb managed to convince Rails to precompile that file too.

A quick (sorta) precompiling, git add && push and Capistrano deploy later, everything finally came together and worked. Phew!

Goals for tomorrow: stop worrying about deployment and go deeper in pure Rails code. Add some custom CSS, more logic, and get some tests up and running.
