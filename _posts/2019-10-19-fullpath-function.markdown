---
layout: post
title:  "Getting the absolute path of a file"
date:   2019-10-19
categories: bash scripting snip
---

When you need to fetch the absolute path of a file, using `readlink` is the handiest way to do it:

```bash
readlink -f some_script.py
```

Or, if you have trouble remembering flags, you can use a minimal function as an alias:

```bash
fullpath() {
    # Print out the absolute path for a file
    readlink -f "$1"
}
```
