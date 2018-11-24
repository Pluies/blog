---
author: Florent
date: 2013-07-25 03:44:12+00:00
draft: false
title: Pushing bookmarklets to their limits
type: post
url: /blog/2013/pushing-bookmarklets-to-their-limits/
categories:
- Programming
---

I recently had to implement a new functionality for an internal web application:Â a button to download a specially-formatted file. The right way to do it is, of course, to deploy server-side code generating the needed file in the backend and make it accessible to the user via the front-end. The application in question is an important company-wide production system and I was on a hurry, so I decided to go the Quick way rather than the Right way 1.

Luckily, all the necessary information to create the file turned out to be accessible on a single web page, which meant I could create a user-triggered script to gather it from this page.

There are several ways for a user to inject and run custom (as in non-server-provided) javascript on their machine, such as using a dev console or a dedicated tool like Greasemonkey. But the best balance between ease of development and âcomparativelyâ good user-experience is [bookmarklets](http://en.wikipedia.org/wiki/Bookmarklet).

A bookmarklet is an executable bookmark. In practice, rather than being a normal URI such as:

    
    http://example.com


They are of the form:

    
    javascript: /* arbitrary js code */


All a user has to do is to add the bookmarklet to the bookmarks bar or menu of their browser of choice, click on it whenever they want to run the specified snippet of code against the current page, and said snippet will be ran.

To come back to our problem, the task at hand was to gather information on the page and make it downloadable as a text file with a custom extension.

Gathering the information was the easy part â a few strategically-placed querySelectorAll and string wrangling gave me exactly what was needed. The tricky part turned out to be creating a file.

How indeed do you create a downloadable file when you have no access to a server to download it from?

As it turns out, there exists a little-known provision of HTML link tags (<a> â </a>) that allows for embedding files as base-64 encoded strings in the tag's _href_ element itself. We can control what goes into this tag through javascript, hence we can generate and embed the file on-the-fly!

The last roadblock was to initiate the download action automatically2, rather than requiring the user to click on the bookmarklet, then on a 'Download' link. One would think it's just a matter of clicking the newly-created link. Yes, but... In javascript, creating a link element is one thing, but clicking it is another âÂ Firefox and IE allow the straightforward link.click(), but Chrome has historically only allowed click() on input elements. We have to dig deeper then, and manually generate a mouse event and propagate it to the link element3.

The following bookmarklet is what I ended up using as a prototype. It extracts information from a page, generates a specifically-formatted file containing the information, and fires up the download window:



If you wish to use this code sample to do something similar, remember to strip off comments and delete linebreaks, as the bookmarklet must be on one line.




#### Footnotes


1: the prototype worked, but the use-case I imagined for it turned out to be quite far removed from the true need. I did end up going the Right way ;-), learning a bit in the process though.

2: Respectively presenting the Open with/Save as dialog (Firefox) and downloading the file directly (Chrome).

3: Hat tip to [StackOverflow](http://stackoverflow.com/questions/8801570/simulate-a-click-on-a-tag-in-chrome) for this technique.
