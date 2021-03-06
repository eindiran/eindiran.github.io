---
layout: post
title:  "Compiling st for Ubuntu 18.04"
date:   2020-10-27
tags: ubuntu linux ricing
categories: snips
---

Recently I wanted to compile [Luke Smiths' fork of `st`](https://github.com/LukeSmithxyz/st), the [Suckless simple terminal](https://st.suckless.org/).
The compilation setup is tailored to Arch out-of-the-box, so I made some changes to get everything to work on Ubuntu 18.04.

Notably, I needed to:
1. Install a number of dependencies using `apt-get`.
2. Compile and install [HarfBuzz](https://github.com/harfbuzz/harfbuzz), the text shaping engine used by `st`.

The main roadblock was that the compilation instructions from the HarfBuzz repository use `meson` and running `meson build && meson test -Cbuild` resulted in some `meson` lexer error that wasn't listed in the GH issues.
Given how little I know about `meson`, I wasn't ecstatic about figuring out the issue.
Thankfully, HarfBuzz supports the `autoconf / automake` toolchain as well (though it is being deprecated in favor of `meson`), so I used that instead.

For more info on building HarfBuzz, see [here](https://harfbuzz.github.io/building.html).

```bash
# Clone the required repos:
cd Workspace
git clone https://github.com/LukeSmithxyz/st.git
git clone https://github.com/harfbuzz/harfbuzz.git

# Now use apt-get to install the packages you'll need.
# Only one of the two commands below is required:
# If you use autoconf & automake like I did, the meson and ragel packages are unnecessary.
# sudo apt-get install -y meson ragel
# If instead you go with the meson build, autoconf and automake are unnecessary.
sudo apt-get install -y autoconf automake
# These packages are what you will need in either case:
sudo apt-get install -y libtool pkg-config gtk-doc-tools gcc g++ libfreetype6-dev libglib2.0-dev libcairo2-dev libx11-dev libxft-dev libxext-dev

# Compile HarfBuzz:
cd harfbuzz
# To use the meson toolchain run:
# meson build && meson test -Cbuild
# To use the autoconf // automake toolchain instead run:
./autogen.sh
make && sudo make install

# Here, double check that the required .so files for HarfBuzz were installed into /usr/local/include/harfbuzz
ll /usr/local/include/harfbuzz
# This should produce a list of several files with names like hb-*.h
# If it doesn't, check to see if they were installed in /usr/include/harfbuzz
# Failing that, you will need to examine the log files in the harfbuzz directory to determine where things
# went awry.

# Now we can compile `st`:
cd ../st
# Apply the edits mentioned below:
vim config.mk
make
# Run the resulting binary:
./st
```

The edits you need to make to `config.mk` are as follows:
```Makefile
X11INC = /usr/include/X11R6
X11LIB = /usr/lib/X11R6
```
