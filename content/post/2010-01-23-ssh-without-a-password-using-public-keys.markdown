---
author: Florent
date: 2010-01-23 00:29:16+00:00
draft: false
title: 'SSH without a password: using public keys'
type: post
url: /blog/2010/ssh-without-a-password-using-public-keys/
categories:
- UNIX
---

If you're often logging remotely into UNIX-like machines using SSH, you may grow tired of having to type and retype your password each and every time. And even more so if you're running rsync, or any other service, over SSH.

To make our life easier, we can establish a secured SSH connection between computers using public/private keys generated with OpenSSH.

In this example, I'll say I want to connect to my _server_ from my _laptop_.



## In a tiny tiny nutshell



We're going to create a set of public/private keys on our laptop, copy the public key on the server and add it to the authorized_keys.



## With some commands and explanations



First of all, we'll generate a [RSA](http://en.wikipedia.org/wiki/RSA) private/public key pair using OpenSSL:

    
    laptop:~$ ssh-keygen -t rsa -b 2048



ssh-keygen will then ask for a place to save the keys (the default ~/.ssh/id_rsa is good) and a passphrase. You may enter a blank passphrase.

So what are these arguments exactly? _-t_ specifies the algorithm to use, and _-b_ is the key length in bits.

To quote the man page:


<blockquote>
-b bits

> Specifies the number of bits in the key to create. For RSA keys, the minimum size is 768 bits and the default is 2048 bits. Generally, 2048 bits is considered sufficient. Â DSA keys must be exactly 1024 bits as specified by FIPS 186-2.
</blockquote>  

For information, on my machine, generating a 1024 bits key is instantaneous, a 2048 bits key takes a second or two, a 4096 bits key is around 10 seconds, and a 8192 bits key took nearly 8mn.

Okay, so now we have two keys sitting in our ~/.ssh folder:

- id_rsa - our private key.
- id_rsa.pub - you guessed it from the extension: our public key.

Second step is to transmit our public key to the _server_, for example using a USB key, or scp:

    
    laptop:~$ scp ~/.ssh/id_rsa.pub mylogin@server:./



Finally, we add this public key to the list of keys the server is going to trust:

    
    server:~$ cat id_rsa.pub >> .ssh/authorized_keys



Voilà ! You can now log into your server with a simple `ssh server` without being asked for a password - only the passphrase if you entered one. And on OS X at least, you can set Keychain Access to remember the passphrase.

  
  


You may want to delete the id_rsa.pub from your home folder on the server afterwards.

A word of advice if you entered a blank passphrase: if someone gets control of your laptop, that person now gets control of your account on the server too. Keep that in mind: public-key authentication is a good thing, but can also be a security hazard if badly used.

At least once you know that a key have been compromised, you can delete it from the authorized_keys file on the server.
