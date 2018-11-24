---
author: Florent
date: 2011-10-01 22:59:17+00:00
draft: false
title: "Rails in a week - day 6"
type: post
url: /blog/2011/rails-in-a-week-day-6/
categories:
- Programming
tags:
- rails
- railsinaweek
---

TL;DR: testing works, I learned i18n, and fixed a bug through TDD.



After writing a simple little [functional test](https://github.com/Pluies/Antipodes/blob/master/test/functional/antipodes_controller_test.rb) and making it run through rake test, albeit slowly, I installed Spork and autotest. From what I gathered, Spork is an RSpec-only thing, so I wrote a few RSpec tests instead of functional tests. After a bit of tweaking, everything was going smoothly between Spork and autotest, all running RSpec, but my file in test/ was ignored. Moving on.

I fixed the bug causing a 500 error when an empty string was entered on the main screen, by writing the following spec:

```ruby
it "should not render en empty request" do
  get :address, :q => ""
  response.should_not render_template("address")
  response.should redirect_to("/")
end
```


Which was red, then green (yay!). I once read that TDD introduced a "strange soothing feeling" (paraphrasing), which is definitely true: seeing automated tests pass contributes quite a lot to one's peace of mind.

I also used the flash hash to flash a notification that the address was invalid. Actually making the notice "flash" (i.e. appear and disappear) took a bit of jQuery ([nothing fancy](https://github.com/Pluies/Antipodes/blob/master/app/views/shared/_notice_div.html.erb), but still!).

Moving on, my next goal was i18n (internationalisation), to make my website switch automatically from English to French depending on the browser's HTTP Accept-language header. After a quick read of the official website's own [guide on i18n](http://guides.rubyonrails.org/i18n.html) (excellent as usual), I modified the files as needed (just noticed I didn't split up my locale files, which maybe I should have done) and set out to find how to change the language depending on the HTTP header.

Apparently this isn't "the Rails way", because it isn't RESTful; two request to the same URL won't give back the same result depending on the browser's configured language. Instead, Rails recommends either 1) an explicit ?locale= parameter in the URL, 2) modifying the routing scheme from, say, /page to /en/page and /fr/page, or even 3) using two separate domains, e.g. myapp.com and myapp.fr. I'm not really fond of the first solution, the second one is okay but should be thought out from the start, and the third one is great but doesn't fit my needs here. HTTP headers it is.

Thankfully, the [http-accept-language gem](https://github.com/iain/http_accept_language) allows you to easily find the best match between which language(s) the browser demands and which language(s) you can provide. Changing the locale according to this data was [a simple before_filter away in the ApplicationController](https://github.com/Pluies/Antipodes/blob/master/app/controllers/application_controller.rb#L4-13). I used [the debugger](http://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-ruby-debug) and curl commands (the -H option allows writing custom headers) to make sure everything was working correctly.

I went back to Spork after a while, not exactly understanding why autotest wasn't doing the same thing as rake test. If I understand correctly, it looks like autotest runs either rspec or test::unit (which doesn't only cover unit tests, but also functional tests, etc, as long as they're under test/), and that Spork being RSpec-only, autotest+Spork only worked with RSpec. After some more research, Spork actually supports test::unit... As a separate gem, spork-testunit. And those two are completely separated: they don't listen on the same port and are called by completely different commands (respectively rspec spec and testdrb).

A quite hackish workaround is to start two different Spork servers with bin/spork TestUnit & bin/spork RSpec, and to add hooks to autotest to launch Unit::Tests too [in the .autotest file](https://github.com/Pluies/Antipodes/blob/master/.autotest#L3-5). It means Test::Unit is only launched after some specs needed re-testing instead of the traditional "a file change, it runs tests", but it still works.

Now, I guess the problem is that a project won't need to have testing done both in RSpec **and** in Test::Unit. I could be wrong about that, but it seems that the goals and end results of both framework are pretty similar.


With all that testing, I didn't have time to implement my country-wide search, which I hope to do tomorrow for this week's final day.
