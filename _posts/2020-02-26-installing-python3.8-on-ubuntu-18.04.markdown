---
layout: post
title:  "Installing Python3.8 on Ubuntu 18.04"
date:   2020-02-26
tags: python
categories: snips
---

By default Ubuntu 18.04 includes Python 3.6. If you want a later version of Python (namely `3.7`, `3.8` or `3.9`), it is possible to install them using an [`apt` PPA](https://help.ubuntu.com/community/PPA). PPAs, or 'Personal Package Archives', are additional repositiories that `apt` can use to search for packages, but they can contain packages that haven't undergone enough testing and validation to end up in one of the main repos: this means that they may not receive timely updates, they might have security problems, they might be seriously broken, etc. Consider this a _caveat emptor_.

The PPA you'll need to install a later version of Python 3 is the [deadsnakes PPA](https://launchpad.net/~deadsnakes/+archive/ubuntu/ppa); deadsnakes has a copy of each version of Python from `2.3` through `3.9`, so you can grab earlier versions as well.

To begin, add the PPA and run `update` to grab the package list.

```bash
sudo add-apt-repository ppa:deadsnakes/ppa
sudo apt update
```

Then just install the version of Python you need:

```bash
sudo apt install python3.7
sudo apt install python3.8
sudo apt install python3.9
```

Note that it won't be installed over your system copy of Python 3, so you'll need to invoke it with `python3.X` rather than `python` or `python3`.