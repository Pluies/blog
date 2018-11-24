---
author: Florent
date: 2016-07-09 12:41:24+00:00
draft: false
title: Security & convenience
type: post
url: /blog/2016/security-convenience/
---

Last week I needed to change my defective French SIM card, from Free (who as an aside are an awesome ISP and equally good mobile provider). I happened to be in Paris so I decided to go to the Free shop, as I thought it'd be easier then getting a new SIM card send to my address on file (my parent's address in France) given I now live in the UK.

When I got to the counter, I was met by a friendly enough Free guy (let's call him _A._) who told me it was no problem, I just needed my Free login and password and we'd be on our way. Cool! Adhering to password Best Practice™, I store all my credentials in Lastpass, so I just had to login into Lastpass to get my stuff and go.

Now, being also mindful that having one big repo of passwords is valuable and high-risk, I have 2FA on this account with a Yubikey, so I can't access it from e.g. my phone.

I didn't have my laptop on me, but my fiancé did, so we tried to use hers to access Lastpass, tethered to her phone. Being secure and all, Lastpass realised this attempt came from a "new location" and asked me to confirm it was me by sending a code by email. Email which I couldn't access from my phone, because, hey, SIM card's broken.

Now thankfully, I keep my email password separate from Lastpass and do remember it, so I could just log into Gmail on the laptop and get that code!

But email is also a very valuable target, the [backdoor to your systems](http://www.xsolutions.com/2014/03/email-the-hackers-backdoor-to-your-system/) used by password recovery mechanisms, so I have 2FA there as well! Instead of my Yubikey, I use Google Authenticator to provide [TOTP](https://en.wikipedia.org/wiki/Time-based_One-time_Password_Algorithm) (more factors, more good, right?). TOTP which sadly failed mysteriously -- I realised later on that removing the battery to take the SIM card out had reset the date and time to factory settings, which breaks the _Time_ in _Time-_based One-Time Password.

Thankfully, at this point _A._ took pity of me and told me he shouldn't, but he could let me use the employee wifi to get the email from my phone (already authenticated = no 2FA), which could get the lastpass code, which could get the Free credentials. Success! My random 30-chars password was finally here.

When seeing the password, _A._ went a bit blank. "Oh... You've changed it", he said - well yes, why? Because this password needs to be entered through a clunky touch-based interface on the kiosk. Five minutes and three tries later, and my new SIM card was finally here.

Next time, I'll do it online.
