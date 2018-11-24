---
author: Florent
date: 2011-09-23 22:43:40+00:00
draft: false
title: "Rails in a week - day 2"
type: post
url: /blog/2011/rails-in-a-week-day-2/
categories:
- Programming
tags:
- rails
- railsinaweek
---

TL;DR: I have a terribly ugly first draft of the application working!

Morning: spent finishing reading the [Getting Started guide](http://guides.rubyonrails.org/getting_started.html) and beginning the [Rails Tutorial](http://ruby.railstutorial.org/).

Afternoon: so, let's get down to maps...
What's cool in Rails is that there are plenty of gems, and you just have to plug them in, right?

[GoogleMapsForRails](https://github.com/apneadiving/Google-Maps-for-Rails) seems like the right tool for the job.

After trying to get my posts to be geolocalized... Success! It took some time to get a marker on the maps, because I thought the locations were created on-the-fly by a geocoding of the address returned by the model, when it actually just fishes the database for the lat/lng data. I had to display the json sent by the controller in rails to confirm that nothing was sent, then add a dummy post in the db with some lat/lng data.

So it seems that geocoding (the process of finding lat/lng coordinates from a string, e.g. "main street, san francisco" => [37.790621,-122.393355]) isn't done by GoogleMapsForRails. What shall I use? Googling suggests [Geokit](http://geokit.rubyforge.org/), but separating the gem from its Rails counterpart sounds strange to me. And apparently it doesn't work for Rails 3. Some more research, and the [Geocoder](https://github.com/alexreisner/geocoder) gem turns up: looks good!

Some more time working with the bolts and nuts... And ta-dah! A first version is working.

The code is up [on Github](https://github.com/Pluies/Rails-in-a-week/tree/master/sample). To get the desired results:

http://localhost:3000/a/washington gives a straightforward geocoding for "washington" and displays it on a map.

http://localhost:3000/b/washington finds the opposite coordinates (i.e. the antipodes) and displays it on a map.



Coming up tomorrow: making things pretty, *testing*, then deploying.
