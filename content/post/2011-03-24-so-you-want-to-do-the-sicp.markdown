---
author: Florent
date: 2011-03-24 22:57:29+00:00
draft: false
title: So you want to do the SICP...
type: post
url: /blog/2011/so-you-want-to-do-the-sicp/
categories:
- Programming
---

That's awesome! But maybe you don't know where to start.

So here we go!


# Wait, the what?


Structure and Interpretation of Computer Programs, a.k.a. the SICP, is an MIT class teaching computer languages turned into a book.

Why should you care? I'll let [Stack Overflow answer](http://stackoverflow.com/questions/1711/what-is-the-single-most-influential-book-every-programmer-should-read):


<blockquote>Some classics [...] teach you the effective working habits and the painstaking details of the trade. Others [...] delve into the psychosocial aspects of software development. [...] These books all have their place.

SICP, however, is in a different league. It is a book that **will enlighten you**.  It will evoke in you a passion for writing beautiful programs.  Moreover, it will teach you to recognize and appreciate that very  beauty. It will leave you with a state of awe and an unquenchable thirst  to learn more. Other books may make you a better programmer; **this book will make you a programmer**.</blockquote>


If you're not sold on the SICP by this point, I'm afraid I can't help you.




# The book


The full material for the book, including lessons and the exercises, is available on the MIT website:

[http://mitpress.mit.edu/sicp/full-text/book/book.html](http://mitpress.mit.edu/sicp/full-text/book/book.html)

Of course, you will need to do the exercises to fully grasp the SICP. The exercises are easy at first and get progressively more challenging. You'll find a lot to make you think, and some concepts are guaranteed to make your head spin.

The language used to teach the SICP is Scheme, a Lisp dialect. This makes the SICP a gentle introduction to functional programming, made trendy again by the likes of Erlang, Haskell, Scala, Clojure, and even Arc if you're an HN reader.

Okay, but doing the exercises without ever testing is not that motivating. What you need is a Scheme REPL!




# A REPL


REPL stands for Read-Eval-Print-Loop. For example, bash could be considered a REPL: enter lines of code, they're interpreted and results are printed out. Repeat.

Several good Scheme REPL exist, such as Gambit Scheme. If you're on OS X with Homebrew, just type brew install gambit-scheme and launch it with scheme-r5rs in command-line. You're good to go!

If you don't really want to mess with Scheme locally, you can use the awesome online REPL here:

[http://sisc-scheme.org/sisc-online.php](http://sisc-scheme.org/sisc-online.php)

(NB: copy and paste doesn't work on OS X, and apparently it doesn't work with Firefox 4 on either OS X or Windows. Can anyone confirm?)

This is all good and well, but what if you're stuck?




# The answers


Numerous people over the web have posted their take on the SICP exercises. One of the best resources is the Scheme community wiki:

[http://community.schemewiki.org/?sicp-solutions](http://community.schemewiki.org/?sicp-solutions)

If you trust me enough, you can see [my take on the exercises on Github](https://github.com/Pluies/SICP).



There it is. You don't have any excuse not to do the SICP now, you lazy bum.

Happy hacking!



**Edit**: as always, [the Hacker News discussion](http://news.ycombinator.com/item?id=2370617) is very insightful.
