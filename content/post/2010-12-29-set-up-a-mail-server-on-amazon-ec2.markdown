---
author: Florent
date: 2010-12-29 00:35:12+00:00
draft: false
title: Set up a mail server on Amazon EC2
type: post
url: /blog/2010/set-up-a-mail-server-on-amazon-ec2/
categories:
- UNIX
---

This post will explain how to set up a Postfix mail server on an EC2 instance.

First, a word of warning: Amazon IPs generally aren't highly considered, spam-wise. Meaning that even if you take all the precautionary steps, your emails might end up in spam folders. If email is business-critical for you, you might want to consider other options: host your mail server somewhere else? Use something like [SendGrid](http://sendgrid.com/)?

This said, let's dive in!


## Prerequisites


I assume you have the following:



	  * A domain name, with control over the DNS records
	  * An EC2 account



## Pick an AMI


Let's start by creating an EC2 instance. I began with the vanilla AWS Linux micro instance, which seem to be somehow Fedora-based, and it was a pain. Now do yourself a favor and pick a Debian-based OS. It will make things much more easier.

[Eric Hammond](http://alestic.com/) and Canonical themselves provides Debian and Ubuntu AMIs, which are a great first step. You can even bypass the whole Postfix config by using [one of these AMIs](http://flurdy.com/docs/postfix/#ec2_ami).

Assign an elastic IP to the instance you launched. We will need it for the DNS setup.


## Configure Postfix


Now's the time to be very lazy and just redirect you to [Ivar Abrahamsen](http://flurdy.com/)'s excellent [howto on setting up Postfix](http://flurdy.com/docs/postfix/). Actually, most of what I'm writing right now can be found on his howto, but let's not stop at technicalities.


## Configure your DNS


The most important step in having your email properly delivered is in your DNS configuration.

The first step is to define an A record for your Amazon Elastic IP, for example mail.mydomain.com. This will be used to set up a reverse DNS on your web server, so that other SMTP servers know that you're not a spam relay.

Then add an MX record to the address you just defined, for example mail.mydomain.com. Now each SMTP server sending mail to mydomain.com will contact mail.domain.com, which in turn points to your EC2 instance. Awesome!

The next step is to modify your [SPF record](http://en.wikipedia.org/wiki/Sender_Policy_Framework). I'll let you work out the details with the spec and Ivar's howto, and as an example here is the SPF record for remaildr:

    
    remaildr.com.        1800    IN    TXT    "v=spf1 mx ip4:50.16.218.96 include:mx.ovh.com ~all"


This SPF allows MX servers and the IP address 50.16.218.96 (i.e. the EC2 instance) to send mail for [remaildr.com](http://remaildr.com). Only "MX" should be enough, no need for the IP in particular ? Well, I thought so, but it didn't work so I added the IP address. Now it works. If anyone has an idea why, I'm all ears.

The include:mx.ovh.com is automatically added by OVH themselves and is not a problem in our case.

You can use the dig command to check if your DNS settings are properly set. For example, the SPF field was retrieved with a:

    
    $ dig remaildr.com in txt


As a bonus, you might be interested in setting up DKIM (cryptographic email signing), a half of which takes place in your DNS. I'll once again refer you to Ivan's howto because it's _that_ good.


## Tell Amazon you'll be sending emails


By default, [Amazon limits the amount of email you can send from an instance](http://aws.amazon.com/ec2/faqs/#Are_there_any_limitations_in_sending_email_from_EC2_instances). You can ask them to remove that limitation very easily though, through [that page](https://aws-portal.amazon.com/gp/aws/html-forms-controller/contactus/ec2-email-limit-rdns-request).

This form also allows you to set up the reverse DNS I was telling you about. Go on, do it! Amazon usually answers to this form within 1-2 days.


## Done!


That's it!

Do you end up in spam folders? Try the test at [AllAboutSpam](http://www.allaboutspam.com/), and check if everything's alright. It covers about any issue your server might have.
