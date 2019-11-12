---
layout: post
title:  "Some useful keyboard shortcuts for Xfce"
date:   2019-10-21
tags: linux xfce
categories: articles
---

<style>
table{
    border-collapse: collapse;
    border-spacing: 0;
    border:1px solid #000000;
}

th{
    border:1px solid #000000;
    background: #a9a9a9;
}

tr{
    border:1px solid #000000;
    background: #d3d3d3;
}

tr:nth-child(even) {
  background: #d3d3d3;
}

tr:nth-child(odd) {
  background: #ffffff;
}

td{
    border:1px solid #000000;
}

.highlighter-rouge {
   background: inherit;
}
</style>


I've been using [Xfce](https://en.wikipedia.org/wiki/Xfce) as my desktop environment since college, shortly after I switched to Linux for my daily driver. At the time, I really enjoyed [distro-hopping](https://en.wikipedia.org/wiki/Distro-hopping) and my operating system seemed to be reinstalled once every few weeks for a while. During that period, I played around with different flavors of Arch, Fedora, Debian and Ubuntu before realizing that ultimately the only things that really matter about a distro are its package manager and its desktop environment. I had tried out a few desktop environments and window managers and the one that stuck was Xfce.  There are a pretty wide variety of desktop environments in Linuxland, ranging from extremely bare-bones to hyper-bloated memory hogs. Xfce manages to strike the right balance for me most of the time: fairly light-weight while still retaining all the ancillary software of a fully functional DE, meaning that you don't need to separately install a file manager, a window manager, a desktop manager, a power manager, a settings panel, etc.

A big plus for me at the time was that Xfce isn't really a keyboard-first environment (cf. [i3](https://en.wikipedia.org/wiki/I3_(window_manager)) or [awesome](https://en.wikipedia.org/wiki/Awesome_(window_manager))), which meant that I didn't need to completely abandon a mouse-based workflow while I was getting used to Linux in general. Over the years, my workflow has gradually become more keyboard-centric (enough so that I've been considering a switch over to i3 or dwm, but that's a topic for another post), so I decided to write this article to record the various Xfce-specific shortcuts I have used to enable that transition.

#### Xfce shortcuts

Some of the shortcuts that I'll include [below](#my-shortcuts) are Xfce defaults (i.e. they come baked-in with a new install of Xfce), but some are shortcuts that I've added. In order to begin adding our own shortcuts, we should first take a look at what shortcuts are and how Xfce manages them.

__Shortcut types:__

There are two distinct types of shortcuts:

* __Command Shortcuts__ (also known as __Application Shortcuts__) are shortcuts that invisibly open a new shell, run a command in it and then close the shell. Xfce intends for these shortcuts to be used primary for launching applications, but you can use them for almost anything. To add a new Command Shortcut in Xfce, open _Keyboard_ and select the _Application Shortcuts_ tab. Click _Add_, then enter a command (i.e. what you would run in a shell to accomplish the task). Click _Okay_: this will launch a new popup that will wait for you to press the key combination you want to use for the shortcut. Once you're happy with the combination, click _Okay_ again, and the Command Shortcut will be defined.


![Command shortcut creation example](/assets/images/command-shortcut-example.png)

* ___xfwm4_ Shortcuts__ are useful for controlling actions performed by the Xfce window manager. They can be used to perform actions like minimizing a window, switching workspaces, or launching the start menu. For shortcuts that control _xfwm4_, instead you'll want to open _Settings Editor_, select _xfce4-keyboard-shortcuts_, and click _New_. Then, in the _Property_ section, enter `/xfwm4/custom/<Key1>Key2` and add a value from the list of _xfwm4_ controls. For example, here is a command (`Alt` + `Delete`) to delete the current workspace:


![xfwm4 shortcut creation example](/assets/images/settings-editor-custom-xfwm4-command.png)


#### My shortcuts

_Note: There is a legend describing the modifier keys [below](#key-sumbol-legend)._

__Command Shortcuts:__


| Shortcut       |  Command or Effect |  Default? | Notes    |
|:--------------:|:--------------:|:--------------:|:--------------:|
|  `<Alt>` +  `-` |  `amixer -D pulse sset Master 5%-`  | no |  Decrease volume by 5% |
|  `<Alt>` +  `=` |  `amixer -D pulse sset Master 5%+`  | no | Increase volume by 5% |
|  `<Super>` + `Z` | `xdotool click 1` | no | Right-click |
|  `<Super>` + `X` | `xdotool click 2` | no | Middle-click |
|  `<Super>` + `C` | `xdotool click 3` | no | Left-click |
|  `<Ctrl>` + `<Alt>` + `T` | `exo-open --launch TerminalEmulator` | no | Launch the default terminal emulator             |
|  `<Super>` + `T` | `exo-open --launch TerminalEmulator` | no | Launch the default terminal emulator             |
|  `<Super>` + `F` | `exo-open --launch FileManager` | no | Launch the default GUI file manager               |
|  `<Super>` + `M` | `exo-open --launch MailReader` | yes | Launch the default email client             |
|  `<Super>` + `B` | `exo-open --launch Browser` | yes | Launch the default browser             |
|  `<Super>` + `R` |  `xfce4-appfinder` |  yes |  Search for any application, similar to Launchpad on macOS |
| `<Alt>` + `<F2>` | `xfrun4` | yes | Search for an application, similar to Spotlight search on macOS |
| `<Ctrl>` + `<Alt>` + `L` | `xflock4` | yes | Lock the screen (launching Xscreensaver if enabled) |


__xfwm4 Shortcuts -- Window Management:__

| Shortcut       |  Command or Effect |  Default? | Notes    |
|:--------------:|:--------------:|:--------------:|:--------------:|
| `<Ctrl>` + `<Esc>` | Launch start menu | yes | |
|`<Super>` + `<Tab>` | Cycle focus between windows of the same application | yes | Allows you to quickly change which window is focused w/i a workspace, but only between windows belonging to the same application|
|`<Alt>` + `<Space>` | Open popup menu for current window | yes | This opens the menu that's usually available in the top left |
| `<Alt>` + `<Tab>` | Cycle through windows within the current workspace | yes | |
| `<Alt>` + `<Shift>` + `<Tab>` | Cycle through windows within the current workspace, in reverse | yes | |
|`<Alt>` + `<Shift>` + `<Page Down>` | Lower current window | yes | Can be used to cycle through windows w/i a workspace |
|`<Alt>` + `<Shift>` + `<Page Up>` | Raise current window | yes | Can be used to cycle through windows w/i a workspace |
| `<Alt>` + `<F4>` | Close current window | yes | Closes the window that currently has focus |
|`<Alt>` + `<F5>` | Horizontally maximize current window | yes | |
|`<Alt>` + `<F6>` | Vertically maximize current window | yes | |
|`<Alt>` + `<F7>` | Maximize current window | yes | |
|`<Alt>` + `<F8>` | Make current window sticky | yes | When a window is made sticky, it becomes visible in all workspaces |
|`<Alt>` + `<F9>` | Hide current window | yes | |
| `<Alt>` + `<F11>` | Toggle fullscreen mode | yes | This will toggle fullscreen mode on the focused window |
|`<Ctrl>` + `<Alt>` + `D` | Minimize all windows/show the desktop | yes | |


__xfwm4 Shortcuts -- Desktop Management:__

| Shortcut       |  Command or Effect |  Default? | Notes    |
|:--------------:|:--------------:|:--------------:|:--------------:|
|`<Alt>` + `<Insert>` | Create new workspace | yes | |
|`<Alt>` + `<Del>` | Delete the last workspace | yes | _Note: this does NOT delete the current workspace_|
|`<Ctrl>` + `<Alt>` + `→` | Cycle forwards through workspaces | yes | |
|`<Ctrl>` + `<Alt>` + `←` | Cycle backwards through workspace | yes | |
|`<Ctrl>` + `<Alt>` + `<End>` | Move currently focused window to the next workspace | yes | |
|`<Ctrl>` + `<Alt>` + `<Home>` | Move currently focused window to the previous workspace | yes | |
|`<Ctrl>` + `<F[1 - 12]>` | Jump to a numbered workspace | yes | Ex: to go to the 6th workspace, use `<F6>` |
|`<Ctrl>` + `<Alt>` + `[0-9]` | Move the currently focused window to a numbered workspace | yes | Ex: to go to the 3rd workspace, use `3` |


#### Key Symbol Legend

If a key isn't in the legend, then it should just match the name described on most keyboards (eg `<Alt>` is just the `Alt` key).

| Key Symbol     | Key Description   |
|:--------------:|:--------------:|
| `<Del>`               | `Delete` key  |
| `<Ctrl>`               | `Ctrl` or `Control` key |
| `<F[1-12]>` | The function keys, `F1` through `F12` |
| `<Space>` | Spacebar |
| `<Super>` | The "Windows" key, though it may be another symbol on some keyboards |
| `↑` | Up arrow key |
| `→` | Right arrow key |
| `←`| Left arrow key |
| `↓` | Down arrow key | 


#### Using Xfce

If Xfce sounds like your kind of thing, you can download it [here](https://xfce.org/) or try out a Linux distro that comes with it like [Xubuntu](https://xubuntu.org/) (based on Ubuntu) or [Manjaro](https://manjaro.org/get-manjaro/) (based on Arch). It is available on some non-Linux Unix-like OSes: basically any Unix-like OS that can support [X11](https://en.wikipedia.org/wiki/X_Window_System) should have it, including the [BSDs](https://www.linuxhelp.com/how-to-install-xfce-desktop-in-freebsd) and [macOS](https://ports.macports.org/port/xfce/summary).