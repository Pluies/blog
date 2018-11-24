---
author: Florent
date: 2010-11-11 20:59:46+00:00
draft: false
title: A bit of Terminal-fu
type: post
url: /blog/2010/a-bit-of-terminal-fu/
categories:
- OS X
- UNIX
tags:
- bash
- OS X
- Terminal
---

Yesterday, my little brother was typing something on a linux bash and suddenly went back to the beginning of the line with a simple Ctrl-a. It blew my mind.

I don't know why, but it never occurred to me to look for shortcuts in Terminal (and bash in general), other than Ctrl-c for badly behaving processes. I just cursed myself and frantically typed on the left arrow key each time I typed cd instead of cp.

Turns out bash has plenty of them, and here are a few useful ones I'm really glad to know now:
Beginning of the line: Ctrl+a
End of the line: Ctrl+e
Delete the word under the cursor or before: Ctrl+w
Delete all chars before the cursor: Ctrl+u
Delete all chars after the cursor: Ctrl+k

Apparently these shortcuts work in a lot of text fields, everywhere.

You can also move the cursor word-by-word by typing Esc, then f or b. It's not really practical though, so you'd be better of remapping the following keys in Terminal Settings > Settings > Keyboard:
control cursor left: \033b (\033 is actually Esc)
control cursor right: \033f

Now you can swiftly move word-by-word with Alt+left arrow and Alt+right arrow.


I guess the lesson here is there's always to learn from your siblings â especially the geeky ones.
