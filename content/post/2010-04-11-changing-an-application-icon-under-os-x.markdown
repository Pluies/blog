---
author: Florent
date: 2010-04-11 22:17:08+00:00
draft: false
title: Changing an application icon under OS X
type: post
url: /blog/2010/changing-an-application-icon-under-os-x/
categories:
- OS X
tags:
- minitip
- OS X
---

I don't like the default icon for Preview.app in OS X.

The sight of that child, giving me this creepy grin, sitting here in the Dock while I'm browsing pictures, is just weird.

![Icon for preview.app](/blog/wp-content/uploads/2010/04/Preview.app_.png)

There are two ways to make him go away.



# The hard way



I call this method the hard way because it involves having another .icns file (the filetype for OS X icons), and navigating through folders supposed to be hidden. But it doesn't matter, you're a hardcore user!

Right-click Preview.app and click "Show Package Contents".
Navigate to Contents/Resources.
Replace Preview.icns with the icon of your choice.



# The easy way



This method allows you to replace an icon with another application's icon.

Open the information panel of said other application (Cmd+i in the Finder).
Click on the big icon at top-left (not the one in the menu bar).
It will appear highlighted:


![The information panel with an highlighted icon](/blog/wp-content/uploads/2010/04/Pictures-+-highlight.png)

Enter Cmd+c to copy it.

Open Preview.app's information panel.

Click on the icon:

![Preview.app's information panel before changing the icon](/blog/wp-content/uploads/2010/04/Preview-before.png)

Enter Cmd+v.

Voilà !


![Preview.app's information panel after changing the icon](/blog/wp-content/uploads/2010/04/Preview-after.png)

Another advantage of this second method is that it also works for disks, folders, and about any file.

You can find a lot of great icons at [InterfaceLift](http://interfacelift.com/icons/downloads/date/mac_os_x/) (though it doesn't seem to be updated very often). The icon I used to replace the child is part of the [Aqua Neue](http://interfacelift.com/icons/details/1858/aqua_neue_%28graphite%29.html) set.
