---
author: Florent
date: 2013-02-02 03:00:29+00:00
draft: false
title: On overflowing stacks
type: post
url: /blog/2013/on-overflowing-stacks/
categories:
- Programming
tags:
- c
- stack overflow
---

I recently set out to implement a few basic data structures in C for the hell of it (and to reassure myself that I can still code C), and ran into an interesting compiler wart...

I was trying to instantiate a static array of 10 million integers (who doesn't?), in order to test insertions and deletions in my tree. However, as you can astutely deduce from the title of this post, this was too much for the stack of my poor program and ended up in a segfault - a textbook stack overflow.

I did not think of that at first though, and tried to isolate the offending piece of code by inserting a return 0; in the main() after a piece of code I knew to be working, and working my way down to pinpoint the issue.

Much to my dismay, this didn't really work out. Why? Check the following code:

```c
#include <stdio.h>

int main (int argc, char** args) {
    printf("Hello world!\n");
    return 0;

    // Uncomment next line at your own risks
    // int boom[10000000];
}
```

Do you think it works with that last line uncommented? You'd be wrong!

    
    [15:20:35]florent@Air:~/Experiments/minefield$ gcc boom.c
    [15:20:40]florent@Air:~/Experiments/minefield$ ./a.out
    Segmentation fault


GCC (4.2.1) wants to instantiate the array _even though it's declared after the function returns_!

Interestingly enough, when you tell GCC to optimise the code, it realises the array will never get reached and prunes it away.

    
    [15:26:06]florent@Air:~/Experiments/minefield$ gcc -O2 boom.c
    [15:26:16]florent@Air:~/Experiments/minefield$ ./a.out
    Hello world!


Clang (1.7) exhibits exactly the same behaviour.

Lessons learnt? return is no way of debugging a program.
