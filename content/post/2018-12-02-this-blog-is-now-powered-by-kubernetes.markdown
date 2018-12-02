---
author: Florent
date: 2018-12-02 18:25:30+00:00
draft: false
title: This blog is now powered by Kubernetes!
type: post
url: /blog/2018/this-blog-is-now-powered-by-kubernetes/
---

I recently read Caleb Doxsey's [article on how suprisingly affordable Kubernetes is for personal projects](http://www.doxsey.net/blog/kubernetes--the-surprisingly-affordable-platform-for-personal-projects) and got inspired to spin it up for myself. I'm familiar with Kubernetes at work, but we run our clusters on top of EC2 instances in AWS, and I've always been curious about how a fully hosted Kubernetes offering like GKE would fare.

Setting up Kubernetes on GKE itself following Caleb's directions was pretty straightforward (well... For the most part – but that's another subject for another post), and I ended up with an empty "hello" page from nginx. Time to do something with it! Let's move the blog there.

Rationale
=========

When I started this blog (or more precisely its first incarnation, [uponmyshoulder.com](https://www.uponmyshoulder.com)) 9 years ago (time flies!), I picked [Wordpress](https://wordpress.com/) as I was using a hosted offer from OVH that came with both PHP and MySQL, and Wordpress was already the best supported and most actively developed open-source blogging engine out there. Overall I've been really happy with Wordpress: the auto-updating mechanism, after some tough beginnings, is now flawless and kept the blog updated for years; the number and quality of themes is dizzying; the plugin ecosystem is massive; out-of-the-box analytics are great...

... but at the end of the day, it's still PHP, requires updates, requires a database, and I don't really need any of the advanced features. Wordpress itself needs attention (I'm not sure how automated upgrades would work in Kube for example), and adding a database would mean either run it in kube (scary) or use Google's hosted database offerings, [Google Cloud SQL](https://cloud.google.com/sql/) (expensive).

My usage of blogging is fairly straightforward (write stuff, post it). So I decided to take the plunge and move my blog to a static site generator, as my usage is fairly basic and does not need any features of Wordpress besides drafting and posting new content. With a statically generated blog, all pages are static HTML and therefore super quick to load, I don't have to worry about potential PHP or Wordpress vulnerabilities, and my content is all backed up in Github.

I decided to go for [Hugo](https://gohugo.io/), as it's got a fair bit of momentum and it ticks all the boxes I'm interested in:

- Generates static HTML
- Write posts in Markdown
- Easy to use

I've also already used Hugo in a previous project, and liked it, so there we go!

Migration
=========

Hugo's website has [a section about migrating from other blogging systems](https://gohugo.io/tools/migrations/) into Hugo, including [migrations from Wordpress](https://gohugo.io/tools/migrations/#wordpress). Following this advice, I ended up using several tools to migrate my existing content:

- I found that [exitwp-for-hugo](https://github.com/wooni005/exitwp-for-hugo) was perfect for migrating text contents from Wordpress. It uses Wordpress's built-in XML exporter and cinsumes the giant XML file to create a hugo folder, complete with Markdown migration. However, it didn't deal with any attachments, such as images.

- The [Jekyll exporter](https://wordpress.org/plugins/jekyll-exporter/) on the other hand didn't produce very clean markdown (after reviewing a couple of posts), but downloaded _all_ images, including resized versions and drafts. Woop! It also imported static pages, but I don't intend on keeping these.

There was still a fair bit of manual intervention: some characters got garbled (especially the `–` or em-dash), a bunch of highlighting I'd done manually in Wordpress using `<pre>` tags had to be taken away and replaced with code blocks, and I replaced all absolute links with relative links. I only had 66 posts so far, so it wasn't a big job by most accounts, but it still took me a couple of hours to go through all posts and ensure everything looked good.

Talking about looking good, I looked for a theme from [Hugos's selection](https://themes.gohugo.io/), and ended up picking the pretty smooth looking [Strata theme from HTML5UP](https://html5up.net/strata). I only tweaked a few things to add some contrast to the text, put my own face in there, and we're in business.

So, is kubernetes the best and easiest way to run a static HTML website?
========================================================================

Uh, no. Definitely not. There are much easier ways of running a blog. But it's a great learning experience. More about that in the next post :)
