---
author: Florent
date: 2010-03-31 17:21:11+00:00
draft: false
title: OS X 10.6.3 broke ncurses
type: post
url: /blog/2010/os-x-10-6-3-broke-ncurses/
categories:
- OS X
tags:
- curses
- OS X
- Seitunes
---

As I was working on my [Seitunes](/blog/tag/seitunes/) project, I noticed something strange: the arrows didn't quite work any more. Instead of their proper action (up & down to change volume, right & left to change song), they all quit the program and printed -respectively- "OA", "OB", "OC" and "OD" on the stdout.

I tried to go back to a working state by progressively deleting new features I was implementing, until I had exactly the same code as the (known working!) 0.5 version, but it was still quitting. gdb told me it wasn't a crash ("Program exited normally").

After some testing, I noticed Seitunes worked on my laptop, but not on my MacBook Pro. The only difference between them being that my laptop was still in OS X 10.6.2, while my mbp has upgraded to 10.6.3.

After a bit of digging into curses functions, I started to suspect keypad(WINDOW *, BOOL) to not work properly after the update. keypad() is supposed to dictate whether getch() should interpret an arrow as one non-ASCII value (with the boolean argument set to TRUE) or a set of ASCII values beginning by the escape char, a.k.a. 27 (FALSE). I explicitly call keypad(stdscr, TRUE) in Seitunes, but the FALSE state would perfectly explain the quit-then-print-two-chars behaviour I had was having: I use the escape character to quit Seitunes.

I wrote two very simple pieces of code -one for keypad true, one for keypad false- that plainly outputs the value returned by getch(). They look like:

    
```c
#include <curses.h>

int main(int argc, char** argv )
{
	int key;
	initscr();
	cbreak();
	noecho();
	nonl();
	intrflush(stdscr, FALSE);
	keypad(stdscr, TRUE);
	printw("getch() should produce only one value when hitting an arrow.\n");
	while ( (key = getch() ) != 'q' ) {
		printw("You entered key %d\n", key);	
	}
	endwin();
	return 0;
}
```
Under both OS X 10.6.2 and Linux Mint 6 "Felicia" (based on Ubuntu 8.10), these programs behave as they're supposed to: when keypad is TRUE, an arrow is shown as a single value; when FALSE, an arrow becomes a set of values.

Under OS X 10.6.3, these two programs behave the same way. Both output several values for an arrow.

I filed a [bug report](https://bugreport.apple.com/) to Apple (vintage interface by the way!).

While this bug is present, we'll have to manually parse the ASCII values for the arrows, which are mapped as follows:

    
    Up      27 79 65	('escape' 'O' 'A')
    Down	27 79 66	('escape' 'O' 'B')
    Right	27 79 67	('escape' 'O' 'C')
    Left	27 79 68	('escape' 'O' 'D')



**Edit**: these values assume OS X 10.6.3 and keypad(stdscr, TRUE), a.k.a. when the bug is present.

If you want to use keypad(stdscr, FALSE) in 10.6.3, the arrows are mapped as:

    
    Up	    27 91 65	('escape' '[' 'A')
    Down	27 91 66	('escape' '[' 'B')
    Right	27 91 67	('escape' '[' 'C')
    Left	27 91 68	('escape' '[' 'D')



**Update, March 1st**: Apple answered to my bugreport (ID #7812788). They told me it was a known issue (duplicate of bug #7812932) currently being investigated by engineering.
