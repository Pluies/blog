---
author: Florent
date: 2010-12-27 14:52:21+00:00
draft: false
title: Remaildr - the tech bits
type: post
url: /blog/2010/remaildr-the-tech-bits/
tags:
- dns
- linux
- remaildr
---

Here are a few small things you might want to know about [http://remaildr.com](http://remaildr.com). Or maybe not, but then again, nobody forces you to read, stranger!


## "Hardware"


Remaildr is hosted on an Amazon EC2 micro instance, benefiting of the free tier offer. Apart from the static IP that will probably end up costing me something, remaildr _should_ be about free.

-- Edit: as of may, remaildr is now hosted on a VPS at OVH. The EBS volume of my EC2 instance blew up on me, and with the free tier coming to end, EC2 would be too costly.


## Network


The remaildr.com domain is registered at OVH, because of the low price and the flexibility they allow on DNS. I added an A record for mail.remaildr.com pointing to 50.16.218.96 (the AWS elastic IP), then modified the MX record for remaildr.com to point to mail.remaildr.com. That way, every email sent to [any_address@remaildr.com](mailto:any_address@remaildr.com) will be sent to the right mail server. Having an A record also allows reverse DNS on the mail server, often used to flag spam.

Other DNS modifications included the [SPF record](http://en.wikipedia.org/wiki/Sender_Policy_Framework), which allows the mail server to actually send emails in behalf of remaildr.com, and a TXT record for [DKIM](http://en.wikipedia.org/wiki/DomainKeys_Identified_Mail) to cryptographically signing outgoing emails.

OVH provides a free 1MB web storage for each domain name subscription, which is more than enough to host the [remaildr.com](http://remaildr.com) website, weighing about 30KB.


## The mail server


The email server at OVH is a run-of-the-mill Debian Squeeze. It runs a Postfix server, configured to forward a few specific email addresses (for example abuse, postmaster and info) to my account, and let everything else go to a catch-all account called remind.

A set of two [Daemonized](http://daemons.rubyforge.org/) Ruby scripts will then do all the work:



	  * receivr.rb will fetch the emails in POP, compute the send date, then put the remaildr to send back into a PostgreSQL database as a Base64-encoded marshalled ruby object (akin to how DelayedJobs works as far as I understand)
	  * sendr.rb will read the database and send all the emails who need to be sent

Of course, [the code](https://github.com/Pluies/remaildr) is on GitHub.

That's about it! Feel free to ask any questions, and I'll answer as well as I can. :)
