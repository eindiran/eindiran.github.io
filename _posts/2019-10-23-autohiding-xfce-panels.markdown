---
layout: post
title:  "Autohiding XFCE panels"
date:   2019-10-23
tags: linux xfce scripting
categories: articles
---

I was browsing Hacker News today and saw [a post](https://simon.shimmerproject.org/2019/10/19/xfce-4-15-development-phase-starting/) about a new release for the Linux desktop environment XFCE.
I have been using XFCE for [quite a while now]({% link _posts/2019-11-11-xfce-keyboard-shortcuts.markdown %}), so I am excited about some of the new features around panels, and thought I would share a script for toggling the autohide and autohide behavior properties of an XFCE panel.
The script was originally based on a snippet found on the XFCE wiki on the `Tips & Tricks` page, which you can see [here](https://wiki.xfce.org/tips).

Currently, I only use two panels, both of which are visible in all workspaces.
The first is the standard taskbar at the top of the screen, which is general kept in an `autohide=false` state.
I also keep a panel in the bottom right of my screen that monitors system resources so that I can get a rough sense of what's going on without needing to open up `htop` by mousing over the panel location:
![Demonstration of mousing over the resource-monitor panel](/assets/resource-monitor-panel-autohide.gif)

The autohide script is shown below:

<script src="https://gist.github.com/eindiran/5f5696a61889c2dfbb423c5be1a70c52.js"></script>

To invoke the script, place it somewhere on your path and run: `autohide_panel.sh -p <panel ID> -a <autohide behavior level>`

You can find the panel ID of each panel by opening the XFCE settings menu for `Panel`, and using the dropdown menu to identify the correct panel. The panel ID is the panel's index in this list.

![Finding the panel ID](/assets/finding-panel-id.gif)

The autohide behavior level is controlled by the `-a` flag, which takes an integer `0`, `1`, or `2`:

* `0`: Never autohide.
* `1`: Intelligently autohide.
* `2`: Always autohide.
