---
author: Florent
date: 2010-05-19 22:30:06+00:00
draft: false
title: A keyboard shortcut to change files colours in the Finder?
type: post
url: /blog/2010/a-keyboard-shortcut-to-change-files-colours-in-the-finder/
categories:
- OS X
tags:
- minitip
- OS X
---

My usual habit (some would call it an intermittent OCD, but meh) of sorting and organizing files and folders to a great extend and my almost as severe relentless longing for optimisation recently met in an existential question: is it possible to colour files in the Finder through a keyboard shortcut?

OS X lets you add colours -or _"labels"_- to a file by right-click or in the Finder's File menu. GUI are cool, but get in the way of efficiency once you know your keyboard inside and out.

Well, after some research, it seems that such a shortcut does not exist. You can't even create a shortcut the usual way, as the "Label" menu point stands for all labels. (I'll eventually describe the _usual method_ in this blog!)

The simplest way to implement such a feature was to create a **set of AppleScripts** that colour files that are currently selected, and launch them via the most amazing [QuickSilver](http://www.blacktree.com/). Or Alfred. Or even Spotlight.

The AppleScripts look like that:

    
```applescript
property file_color : 5
-- replace '5' above with the number for the color you'd like to use:
-- 0=none, 1=orange, 2=red, 3=yellow, 4=blue, 5=purple, 6=green, 7=grey 

tell application "Finder"
	activate
	set items_ to selection
	repeat with item_ in items_
		try
			set label index of item_ to file_color
		on error e
			display dialog e
		end try
	end repeat
end tell
```


This is the purple one. Therefore, I called it scp_SetColourPurple.scpt and dropped it off somewhere QuickSilver indexes - proceed this way for each colour you want to add.
  
  
All it takes now to colour a set of files is to select them in the Finder, type in Ctrl+Space (to summon QuickSilver) and the three letters to your colour of choice - scp to set the coulour to purple, scr to set colour to red, scy to set colour to yellow...
  
  

(Full disclosure: the above code was originally found somewhere on the internet, I can't find where right now. If I find the link again, or if someone can point it to me, I'll give props to the original author.)
