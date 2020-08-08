---
layout: post
title:  "Controlling a Selenium WebDriver through a Python ContextManager"
date:   2020-02-24
tags: python
categories: snips
---

Over time, I've found myself less and less willing to close things manually in Python: ever since I found out about context managers and the `with` statement, I find myself writing context managers to handle any managed resource I need to deal with.

Want to open a file? Do it in a context manager. Want to connect to a database? [Do it in a context manager.](https://gist.github.com/eindiran/529a6b14b2029254d9b3313de3ac5638) Want to pause garbage collection? [Do it in a context manager](https://gist.github.com/eindiran/802ad417a8e3926da60a1b8666430c23).
