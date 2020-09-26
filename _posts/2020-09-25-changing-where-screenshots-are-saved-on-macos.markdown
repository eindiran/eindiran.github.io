---
layout: post
title:  "Changing where screenshots are saved on macOS"
date:   2020-09-25
tags: macos
categories: snips
---

By default, macOS saves screenshots to the Desktop; if you are like me and like to keep your desktop empty, this can be pretty irritating.

The irritation finally hit a critical mass today and I decided to figure out how to solve the problem. I bumped into [this post](https://discussions.apple.com/docs/DOC-9081) on the Apple forums, which has some very clear instructions, but I will reproduce the critical bit here.

Use the `defaults` tool to set the screenshot location to an arbitrary path. `defaults` has a few possible actions, of which a few are relevant to us:

```
read -- Show all of the current defaults values for all applications. If you specify an application using its fully-qualified domain name (eg `com.foo.bar` or `org.baz.quux`), only that application's defaults will be printed out.

delete <domain> -- Nukes all defaults for an application.
delete <domain> <key> -- Delete a specific key-value pair for an application.

write <domain> <key> <value> -- Sets a key-value pair for a domain.
```

This latter option is what we need: for the domain used by the screenshot tool (`com.apple.screencapture`), set the `location` key to the desired path.

```bash
defaults write com.apple.screencapture location /Users/eindiran/Pictures/Screenshots
```

If you haven't created the folder you plan to use, you can create it in Finder or run `mkdir -p /my/new/path`
