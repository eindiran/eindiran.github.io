---
layout: post
title:  "Fixing Rust compilation issues caused by missing packages, part 2"
date:   2020-02-04
tags: rust linux
categories: articles
---

This series of posts covers a few different Rust compilation errors caused by missing system packages and how to fix them.

You can find the first post in this series [here]({{ site.baseurl }}{% link _posts/2020-02-03-fixing-rust-compilation-issues-caused-by-missing-packages.markdown %}).

### `libclang.so` compilation error

Abbreviated error:
```
Unable to find libclang
```

Full error:

```
error: failed to run custom build command for `onig_sys v69.2.0`

Caused by:
  process didn't exit successfully: `/tmp/cargo-installuq50Y1/release/build/onig_sys-c22eb0db51eb31e2/build-script-build` (exit code: 101)
--- stdout
cargo:warning=couldn't execute `llvm-config --prefix` (error: No such file or directory (os error 2))
cargo:warning=set the LLVM_CONFIG_PATH environment variable to a valid `llvm-config` executable

--- stderr
thread 'main' panicked at 'Unable to find libclang: "couldn\'t find any valid shared libraries matching: [\'libclang.so\', \'libclang-*.so\', \'libclang.so.*\'], set the `LIBCLANG_PATH` environment variable to a path where one of these files can be found (invalid: [])"', src/libcore/result.rs:1165:5
note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace.
```

This one is caused by the fact that Rust depends on `libclang`, and `LLVM` more generally. For more info on how Rust uses `LLVM`, see [here](https://github.com/rust-lang/llvm-project) and [here](https://www.infoworld.com/article/3247799/what-is-llvm-the-power-behind-swift-rust-clang-and-more.html).

#### Fixing the error

If you don't have `clang` installed, the Rust compiler can't do its thing. To fix the error, install `clang` via the `libclang` package.

Debian/Ubuntu:
```
sudo apt-get install libclang-dev
```

On CentOS/RHL/Fedora:
```
sudo yum install clang  # Or replace `yum` with `dnf`
```

Once complete, run `cargo build` again and verify that the error that mentions `libclang` no longer pops up. If it still does, try setting `$LIBCLANG_PATH` to point to the location where `libclang.so` is installed:

```bash
$ find /usr -iname "libclang.so" -print
/usr/lib/llvm-6.0/lib/libclang.so
```

```bash
$ export LIBCLANG_PATH="/usr/lib/llvm-6.0/lib/libclang.so:${LIBCLANG_PATH}"
```
