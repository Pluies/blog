---
author: Florent
date: 2011-11-09 00:26:19+00:00
draft: false
title: Optimising a video editor plugin
type: post
url: /blog/2011/optimising-a-video-editor-plugin/
categories:
- Programming
tags:
- c
- optimisation
---

During the past few weeks, I have been writing [a C++ plugin](https://github.com/Pluies/C41) to grade C41 digital intermediates in [Cinelerra](cinelerra.org), an open-source Linux video editor. [C41](http://en.wikipedia.org/wiki/C-41_process) is the most common chemical process for negatives, resulting in films that look like [this](http://www.ag-photographic.co.uk/ekmps/shops/matt5791/resources/Design/filmstrip.jpg) â you probably know it if you've ever shot film cameras.

Of course, after scanning those negatives, you have to process ("grade") them to turn them back to positive. And it's not as simple as merely inverting the values of each channel for each pixel; C41 has a very pronounced orange shift that you have to take into account.


## The algorithm


The core algorithm for this plugin was lifted from [a script](http://sites.google.com/site/negfix/) written by JaZ99wro for still photographs, based on ImageMagick, which does two things:
- Compute "magic" values for the image
- Apply a transformation to each channel (R, G, B) based on those magic values

The problem with film is that due to tiny changes between the images, the magic values were all over the place from one frame to the other. Merely applying JaZ's script on a series of frames gave a sort of "flickering" effect, with colours varying from one frame to the other, which is unacceptable effect for video editing.

The plugin computes those magic values for each frame of the scene, but lets you pick and fix specific values for the duration of the scene. The values are therefore not "optimal" for each frame, but the end result is visually very good.

However, doing things this way is slow: less than 1 image/second for 1624*1234 frames.


## Optimising: do less


The first idea was to make optional the computing of the magic values: after all, when you're batch processing a scene with fixed magic values, you don't need to compute them again for each frame.

It was a bit faster, but not by much. A tad more than an image/second maybe.



## Optimising: measure


The next step (which should have been the first!) was to actually benchmark the plugin, and see where the time was spent. Using [clock_gettime()](http://linux.die.net/man/3/clock_gettime) for maximum precision, the results were:

~0.3 seconds to compute magic values (0.2s to apply a box blur to smooth out noise, and 0.1s to actually compute the values)

~0.9 seconds to apply the transformation

Optional computing of the magic values was indeed a step in the right direction, but the core of the algorithm was definitely the more computationally expensive. Here's what's to be computed for each pixel:

    
    row[0] = (magic1 / row[0]) - magic4;
    row[1] = pow((magic2 / row[1]),1/magic5) - magic4;
    row[2] = pow((magic3 / row[2]),1/magic6) - magic4;



With row[0] being the red channel, row[1] the green channel, and row[2] the blue channel.

The most expensive call here is pow(), part of math.h. We don't need to be extremely precise for each pixel value, so maybe we can trade some accuracy for raw speed?



## Optimising: do better


Our faithful friend Google, tasked with searching for a fast float pow() implementation, gives back [Ian Stephenson's implementation](http://www.dctsystems.co.uk/Software/power.html), a short and clear (and more importantly, working) version of pow().

But we can't just throw that in without analysing how it affects the resulting frame. The next thing to do was to add a button that would switch between the "exact" version and the approximation: the results were visually identical.

Just to be sure, I measured the difference between the two methods, and it shows an average 0.2% difference, going as high as 5% for the worst case, which are acceptable values.

And the good news is that the plugin now only takes 0.15 to 0.20 second to treat each image, i.e. between 5 and 6 images/second â an 8-fold gain since the first version. Mission accomplished!
