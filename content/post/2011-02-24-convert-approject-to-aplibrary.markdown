---
author: Florent
date: 2011-02-24 19:32:33+00:00
draft: false
title: Convert .approject to .aplibrary
type: post
url: /blog/2011/convert-approject-to-aplibrary/
categories:
- OS X
tags:
- aperture
---

If you ever backed up Aperture projects outside your standard library, you probably noticed the default format for exported albums changed from .approject to .aplibrary in the update from Aperture 2 to Aperture 3.

The Finder correctly reports these new .aplibrary as "Aperture Library", but it seems to have forgotten everything about the old .approject who now appear as standard folders (it appears to be a weird bug on my machine, but still).

So how do we convert our .approject to .aplibrary?



	  * In Aperture 3, pick File > Import > Library/Project... and select your .approject folder. This will effectively re-import your project in the current Aperture Library.
	  * Right-click on the project and select Export > Project as New Library...
	  * Once it's done, delete the project from the current Aperture Library (unless you want a backup or if you have other mischievous plans for your pictures, of course)



That's it! Quite straightforward indeed, but a bit puzzling at first.
