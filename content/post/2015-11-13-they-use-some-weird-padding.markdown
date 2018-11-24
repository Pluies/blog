---
author: Florent
date: 2015-11-13 22:02:40+00:00
draft: false
title: '"They use some weird padding..."'
type: post
url: /blog/2015/they-use-some-weird-padding/
---

A few days ago, a colleague was telling me about a project where she needs to implement a crypto scheme from an external vendor in order to talk to their API over HTTP. For complicated (and probably wrong) reasons, they decided to eschew TLS and develop their own system instead, relying on DES –not even triple DES! Basic DES, the one from the '70s that is [horribly insecure](https://en.wikipedia.org/wiki/Data_Encryption_Standard#Security_and_cryptanalysis) today– and RC4, which isn't great either.

The whole scheme was bad, but my colleague added "and they also use that strange padding scheme - because the plaintext length needs to be a multiple of 8 bytes, at the end of every message, they put seven ["Bell" characters](https://en.wikipedia.org/wiki/Bell_character)!".

The bell character? That's odd. I mean, it's in ASCII, and not usually part of any plaintext, so it's probably safe to use as padding, but... Wait a second – padding with strange characters, all the same? That rings a _bell_!

And indeed it does - it's [PKCS#7](https://en.wikipedia.org/wiki/Padding_%28cryptography%29#PKCS7)!

PKCS#7 is meant to pad a message until it reaches the next block boundary, to use with block ciphers. It works by appending _n_ characters of ASCII value 0x_n_, and of course the ASCII codepoint of the bell character is 0x07!

"Oh, that explains a lot. Now I won't have to add blank spaces until it reaches (x mod 8) + 1 bytes and pad with bell characters", my colleague said. I guess that's the danger when you're given a bad scheme to implement: it's harder to realise when they actually do something right.

(Hat's up to the [Matasano crypto challenges](http://cryptopals.com/): despite doing only level 1 and 2 if the memory serves –it was a while back–, they're super useful for these sort of cryptography basics.)
