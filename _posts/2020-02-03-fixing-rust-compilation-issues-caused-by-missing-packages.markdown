---
layout: post
title:  "Fixing Rust compilation issues caused by missing packages"
date:   2020-02-03
tags: rust linux
categories: articles
---

Recently I've been teaching myself some [Rust](https://www.rust-lang.org/) as one of my projects for 2020. For the most part, I have been working on older, broken-in machines so I didn't encounter any issues with missing packages. However, a few days ago I installed Rust via [rustup](https://rustup.rs/) on a fresh Ubuntu machine and immediately hit a number of issues with missing packages. This series will cover particular Rust compilation errors that are caused by missing packages and how to solve them.

### Installing Rust via `rustup`

Before you beign, you'll need to install Rust. The standard practice is to use `rustup`, a shell-script that can handle all of the heavy lifting for you. You can find `rustup` [here](https://rustup.rs/). Run the following:

```bash
$ curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

If you object to grabbing random scripts off the internet and piping them into a shell, you can use a tool like [`interject`](https://github.com/eindiran/interject) to check the contents of the script before sending it to `sh`:

```bash
$ curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | interject | sh
```

Choose the default installation, which will place the various binaries in the Rust toolchain in `~/.cargo/bin` and `~/.rustup`, as well as modifiying your `$PATH` environment variable to include `~/.cargo/bin`. If you want to make use of `nightly` features, you'll instead need to select the option `2) Customize installation`. Then for the option `Default toolchain? (stable/beta/nightly/none)` select `nightly`.

Once the script completes, you'll have the various Rust tools installed. You can check this by running `rustc --version` and `cargo --version`.

### Compiling a project

Next, you'll want to create a project and attempt to compile it. If you don't already have one in mind, you can try compiling the project I have been working on:  [Bloom](https://github.com/eindiran/bloom), a Rust bloom filter library that contains a number of useful bloom filter variants for handling streaming data.

`cd` into the project directory, then run `cargo install` to fetch the relevant dependency packages from [crates.io](https://crates.io). Once it completes, try running `cargo build`. This is where the problems potentially start.

### `crti.o`/`Scrt1.o` compilation error
`rustc` uses the system linker to handle linking with object (`.o`) and shared object (`.so`) files. On Linux machines, this will be GNU `ld`. If something fails and the error explicitly mentions "linking" or "`ld`", then this is where things went astray.

The error that I encountered:

```
error: linking with `cc` failed: exit code: 1
  |
............
  = note: /usr/bin/ld: cannot find Scrt1.o: No such file or directory
          /usr/bin/ld: cannot find crti.o: No such file or directory
          collect2: error: ld returned 1 exit status


error: aborting due to previous error

error: could not compile `getrandom`.
warning: build failed, waiting for other jobs to finish...
error: linking with `cc` failed: exit code: 1

```

The error is caused by`ld` not being able to find packages used by the `gcc` toolchain to target `32 bit` systems (while your system is natively `64 bit`). `ld` uses an environment variable `$LD_LIBRARY_PATH` to know where to search, so two things may have gone wrong:

1. The relevant package is not installed on your system.
2. The location where this package is installed is missing from the `$LD_LIBRARY_PATH`, preventing `ld` from finding the object files needed.

#### Installing the package

To fix the first error, you'll need to install the add-on packages that `gcc` needs to do cross-compilation for `32 bit` systems.

On Debian/Ubuntu systems (using `.deb` packages):

```bash
$ sudo apt-get install gcc-multilib
```

On CentOS/RHL/Fedora (using `.rpm` packages):

```bash
$ sudo yum install glibc-devel.i686 libgcc.i686 libstdc++-devel.i686 ncurses-devel.i686
# Or use `dnf` instead of `yum` if that is your package manager
```

Try compiling again, and check to see that there are no longer errors complaining about `Scrt1.o` or `crti.o`. If the error persists, then the problem is with the current `$LD_LIBRARY_PATH` variable.

#### Fixing `$LD_LIBRARY_PATH`

Search `/usr` for any files named `crti.o`:

```bash
$ find /usr -iname "crti.o" -print
/usr/lib/x86_64-linux-gnu/crti.o
```

Then add the directory to your `$LD_LIBRARY_PATH`:

```bash
$ export LD_LIBRARY_PATH=/usr/lib/x86_64-linux-gnu:$LD_LIBRARY_PATH
```

Then repeat this step for files named `Scrt1.o`. If the directory containing the file is different than the directory that contained `crti.o`, add it to your `$LD_LIBRARY_PATH` as well (however it is likely in the same directory):

```bash
$ find /usr -iname "Scrt1.o" -print
/usr/lib/x86_64-linux-gnu/Scrt1.o
```

Now try compiling again; the `crti.o`/`Scrt1.o` error should now be gone.
