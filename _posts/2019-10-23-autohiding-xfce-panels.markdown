---
layout: post
title:  "Autohiding XFCE panels"
date:   2019-10-23
categories: linux xfce shell-scripting snip
---

I was browsing Hacker News today and saw [a post](https://simon.shimmerproject.org/2019/10/19/xfce-4-15-development-phase-starting/) about a new release for the Linux desktop environment XFCE.
I have been using XFCE for [quite a while now]({% link _posts/2019-10-21-xfce-keyboard-shortcuts.markdown %}), so I am excited about some of the new features around panels, and thought I would share a script for toggling the autohide and autohide behavior properties of an XFCE panel.

Currently, I only use two panels, both of which are visible in all workspaces.
The first is the standard taskbar at the top of the screen, which is general kept in an `autohide=false` state.
I also keep a panel in the bottom right of my screen that monitors system resources so that I can get a rough sense of what's going on without needing to open up `htop` by mousing over the panel location:
![Demonstration of mousing over the resource-monitor panel](/assets/resource-monitor-panel-autohide.gif)

The script is shown below:

```bash
#!/usr/bin/env bash
#===============================================================================
#
#          FILE: autohide_panel.sh
#
#         USAGE: ./autohide_panel.sh -p <panelId>
#
#   DESCRIPTION: Toggle the autohide and autohide behavior properties of an
#                XFCE panel, which control whether it is visible or not.
#                This script was inspired by the code snippet for autohiding
#                panels on the XFCE Wiki's Tips page:
#                     * https://wiki.xfce.org/tips#xfconf
#
#       OPTIONS: -p <panelId>  -->  Specify the panel ID of the relevant panel.
#                -a <autohide> -->  0, 1, or 2 to hide always, sometimes, or never.
#                -h            -->  Print usage information and exit.
#===============================================================================

set -Eeuo pipefail

PANEL_ID=""
AUTOHIDE_ALWAYS=2
AUTOHIDE_SMART=1
AUTOHIDE_NEVER=0
AUTOHIDE_MODE=$AUTOHIDE_ALWAYS

# Print usage info
usage() {
    printf "Usage: %s -p <panelId> [-a <mode>]\n\n" "$0"
    printf "The autohide modes are as follows:\n"
    printf "\t%s: Never autohide.\n" "$AUTOHIDE_NEVER"
    printf "\t%s: Intelligently autohide.\n" "$AUTOHIDE_SMART"
    printf "\t%s: Always autohide.\n" "$AUTOHIDE_ALWAYS"
    exit "$1"
}

while getopts ":p:h:a:" OPT; do
    case "${OPT}" in
        p) PANEL_ID=${OPTARG}                               ;;
        a) AUTOHIDE_MODE=${OPTARG}                          ;;
        h) usage 0                                          ;;
        *) printf "Unknown option: %s\n" "${OPT}"; usage 1  ;;
    esac
done

# Check that PANEL_ID is valid
if [[ -z "$PANEL_ID" ]]; then
    printf "No panel ID was provided!\n"
    usage 1
elif ! [[ "$PANEL_ID" =~ ^[0-9]+$ ]]; then
    printf "The provided panel ID (%s) was invalid; it must be a positive integer.\n" "$PANEL_ID"
    usage 1
fi

# Check that AUTOHIDE_MODE is valid
if ! [[ "$AUTOHIDE_MODE" =~ ^[012]+$ ]]; then
    printf "Autohide mode was invalid; it must be an integer (0, 1, or 2).\n"
    usage 1
fi

# Locate the autohide property for the panel
AH_PROP=/panels/panel-$PANEL_ID/autohide
AHB_PROP=/panels/panel-$PANEL_ID/autohide-behavior

# Query the xfconf file to determine if the autohide property exists
if xfconf-query -c xfce4-panel -p "$AH_PROP" >/dev/null 2>&1; then
    # The -T flag will (T)oggle an existing boolean property
    xfconf-query -c xfce4-panel -T -p "$AH_PROP"
    xfconf-query -c xfce4-panel -n -p "$AHB_PROP" -t int -s "$AUTOHIDE_MODE"
else
    # Create a new property if one doesn't yet exist
    xfconf-query -c xfce4-panel -n -p "$AH_PROP" -t bool -s false
    xfconf-query -c xfce4-panel -n -p "$AHB_PROP" -t int -s "$AUTOHIDE_MODE"
fi
```

To invoke the script, place it somewhere on your path and run: `autohide_panel.sh -p <panel ID> -a <autohide behavior level>`

You can find the panel ID of each panel by opening the XFCE settings menu for `Panel`, and using the dropdown menu to identify the correct panel. The panel ID is the panel's index in this list.

![Finding the panel ID](/assets/finding-panel-id.gif)

The autohide behavior level is controlled by the `-a` flag, which takes and integer `0`, `1`, or `2`.

* `0`: Never autohide.
* `1`: Intelligently autohide.
* `2`: Always autohide.
