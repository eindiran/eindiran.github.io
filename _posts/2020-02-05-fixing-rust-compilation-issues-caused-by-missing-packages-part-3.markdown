---
layout: post
title:  "Fixing Rust compilation issues caused by missing packages, part 3"
date:   2020-02-05
tags: rust linux
categories: articles
---

This series of posts covers a few different Rust compilation errors caused by missing system packages and how to fix them.

You can find the first and second posts of this series [here]({{ site.baseurl }}{% link _posts/2020-02-03-fixing-rust-compilation-issues-caused-by-missing-packages.markdown %}) and [here]({{ site.baseurl }}{% link _posts/2020-02-04-fixing-rust-compilation-issues-caused-by-missing-packages-part-2.markdown %}) respectively.

### `exec 'cc1plus': execvp` compilation error

Abbreviated error:
```
warning=cc: error trying to exec 'cc1plus': execvp: No such file or directory
```

Full error message:
```
error: failed to run custom build command for `fasthash-sys v0.3.2`

Caused by:
  process didn't exit successfully: `/home/eindiran/Workspace/bloom/target/release/build/fasthash-sys-b0947c682e158ad8/build-script-build` (exit code: 101)
--- stdout
TARGET = Some("x86_64-unknown-linux-gnu")
OPT_LEVEL = Some("3")
TARGET = Some("x86_64-unknown-linux-gnu")
HOST = Some("x86_64-unknown-linux-gnu")
TARGET = Some("x86_64-unknown-linux-gnu")
TARGET = Some("x86_64-unknown-linux-gnu")
HOST = Some("x86_64-unknown-linux-gnu")
CC_x86_64-unknown-linux-gnu = None
CC_x86_64_unknown_linux_gnu = None
HOST_CC = None
CC = None
HOST = Some("x86_64-unknown-linux-gnu")
TARGET = Some("x86_64-unknown-linux-gnu")
HOST = Some("x86_64-unknown-linux-gnu")
CFLAGS_x86_64-unknown-linux-gnu = None
CFLAGS_x86_64_unknown_linux_gnu = None
HOST_CFLAGS = None
CFLAGS = None
DEBUG = Some("false")
running: "cc" "-O3" "-ffunction-sections" "-fdata-sections" "-fPIC" "-m64" "-Wno-implicit-fallthrough" "-Wno-unknown-attributes" "-msse4.2" "-maes" "-mavx" "-mavx2" "-DT1HA0_RUNTIME_SELECT=1" "-DT1HA0_AESNI_AVAILABLE=1" "-Wall" "-Wextra" "-o" "/home/eindiran/Workspace/bloom/target/release/build/fasthash-sys-d287b823bda49218/out/src/fasthash.o" "-c" "src/fasthash.cpp"
cargo:warning=cc: error trying to exec 'cc1plus': execvp: No such file or directory
exit code: 1

--- stderr
thread 'main' panicked at '

Internal error occurred: Command "cc" "-O3" "-ffunction-sections" "-fdata-sections" "-fPIC" "-m64" "-Wno-implicit-fallthrough" "-Wno-unknown-attributes" "-msse4.2" "-maes" "-mavx" "-mavx2" "-DT1HA0_RUNTIME_SELECT=1" "-DT1HA0_AESNI_AVAILABLE=1" "-Wall" "-Wextra" "-o" "/home/eindiran/Workspace/bloom/target/release/build/fasthash-sys-d287b823bda49218/out/src/fasthash.o" "-c" "src/fasthash.cpp" with args "cc" did not execute successfully (status code exit code: 1).

', /home/eindiran/.cargo/registry/src/github.com-1ecc6299db9ec823/gcc-0.3.55/src/lib.rs:1672:5
note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace.

warning: build failed, waiting for other jobs to finish...
error: build failed
```

Here we've encounter a problem with compiling some `.cpp` files used by a Rust package, because our system can't seem to compile the C++, likely because there is no available C++ compiler. To fix this, we're going to install `g++`, the GNU C++ compiler.

#### Fixing the error

__Note:__ You should include the `g++-multilib` package to avoid the kind of cross-compilation issues we saw in part 1 of the series.

Debian/Ubuntu:
```
sudo apt-get install g++ g++-multilib
```

On CentOS/RHL/Fedora:
```
sudo yum install gcc-c++  # Or replace `yum` with `dnf`
```

Once your package manager has finished installing `g++`, kick off another build with `cargo build`. You should see that the error mentioning `cc1plus` no longer appears.
