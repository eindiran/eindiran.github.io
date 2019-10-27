---
layout: post
title:  "Fixing the tiny Finder bug on macOS"
date:   2019-10-26
tags: macos
categories: snips
---

A few days ago, I noticed that there was a tiny, tiny little Finder window on the second desktop of my laptop, which runs macOS High Sierra.
As cute as it is, it started to be quite irritating to me, as I like the desktop to be empty.

![Tiny finder window](/assets/tiny-finder.png)

I had tried a few different things to fix the issue including changing the number of desktop screens, changing the background, changing the way icons appear on the desktop and restarting the machine.
I found [a bug report of the issue](https://discussions.apple.com/thread/5490904), which apparently has persisted in more recent releases of macOS, including Catalina.
The 'fix' isn't quite a fix, as the issue can return at random, but its simple enough that the issue isn't too painful.
Simply close and restart the Finder app, by pressing `Alt` and right-clicking the Finder icon, then selecting `Relaunch` from the pop-up menu.

![Closing finder](/assets/tiny-finder-fix.gif)

Hopefully Apple will deign to finally address this in a future release, but I won't be holding my breath.
