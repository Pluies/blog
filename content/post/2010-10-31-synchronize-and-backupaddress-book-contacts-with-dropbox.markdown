---
author: Florent
date: 2010-10-31 09:56:30+00:00
draft: false
title: Synchronize and backup Address Book contacts with Dropbox
type: post
url: /blog/2010/synchronize-and-backupaddress-book-contacts-with-dropbox/
categories:
- OS X
tags:
- address book
- minitip
---

A nice way to synchronize contacts between your Macs without having to buy a MobileMe account is to have them on your [Dropbox](http://www.dropbox.com/).

Basically, it boils down to moving the folder containing your Address Book data on your Dropbox, then adding a symbolic link to it so Address Book will know where to find its data.

Let's go on bash!

Move the folder:

    
    $ mv -v ~/Library/Application\ Support/AddressBook ~/Dropbox/


Add a symbolic link:

    
    $ ln -s ~/Dropbox/AddressBook/ ~/Library/Application\ Support/AddressBook


Done!

Now you'll only have to add the symbolic link to every Mac you want to synchronize (you may also need to remove the existing AddressBook folder). Another awesome consequence is that you don't have to worry about losing your contacts if your hard drive crashes: they're safe in your Dropbox.

A word of advice though: Address Book was not originally meant to be used this way. It would be wise not to edit your Address Book from the two computers are the same time, for example.
