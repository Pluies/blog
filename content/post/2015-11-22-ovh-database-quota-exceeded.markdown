---
author: Florent
date: 2015-11-22 10:17:29+00:00
draft: false
title: 'OVH: Database quota exceeded'
type: post
url: /blog/2015/ovh-database-quota-exceeded/
---

OVH emailed me a few weeks back telling me that my shared database for the plan that powers uponmyshoulder.com was approaching its (huge!) quota of 25MB, and then again last week to tell me that this time, the quota was reached.

Once you reach the quota, the DB is placed in read-only mode, although SQL ``DELETE`` commands do go through correctly, as we'll see later.

So my first instinct was to see what was wrong, by going into the PhpMyAdmin that OVH gives to each shared DB owner. It confirmed that the database was too big, mainly because of two tables: the main culprit at 9MB was `wp_comments`, the comments on this blog, and the second one at 5MB was its related sibling `wp_commentmeta`. The root cause being, of course, spam: all these comments were properly intercepted and classified as spam by [Akismet](https://akismet.com/), but as long as I didn't purge them, they were still taking valuable disk space.

So I thought I could just delete the comments that Akismet marked as spam (as that info is available directly in the table) and go on with my day, but unfortunately no - the deletion went through, but the table was still marked as being 9MB, including about 7MB of "[overhead](http://stackoverflow.com/questions/565997/in-mysql-what-does-overhead-mean-what-is-bad-about-it-and-how-to-fix-it)". How do we reclaim this overhead? By running `OPTIMIZE TABLE`... Which we cannot do as we're in read-only mode.

At this point, I took a dump of the database, and deleted it through the OVH admin interface, recreated a new database and reimported that dump: solved! The new DB clocked at about 14MB, enough for the foreseeable future.

Lesson learned: clean your spam.

(PS: in the few days that passed between the db clean and me writing this article, I got another 355 spam comments. Yay.)
