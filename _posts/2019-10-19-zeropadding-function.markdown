---
layout: post
title:  "A quick and dirty Bash zeropadding function for batch-renaming files"
date:   2019-10-19
categories: bash scripting snip
---

Recently I needed to rename thousands of numbered files so that the lexical sort order of the files would match the numeric sort order.
The file names looked approximately like this: `some-name_2.xml` or `another-name_302.xml`.
With lexical sort order, the second file `some-name_2.xml` would come _after_ the 102nd file `some-name_102.xml`; the easiest way to get lexical sort order to match numerical sort order is to zeropad the numbers.

I ended up using this function to generate the zeropadded filenames:
```bash
zeropad() {
    # Zero-pad a number in a string
    # Useful for batch renaming files to make lexical
    # sort order the same as numerical sort order
    PADLEN=5
    if [ $# -eq 2 ]; then
        PADLEN="$2"
    fi
    NUM="$(echo "$1" | sed -n -e 's/.*_\([[:digit:]]\+\)\..*/\1/p')"
    PADDED_NUM="$(printf "%0${PADLEN}d" "$NUM")"
    echo "${1/$NUM/$PADDED_NUM}"
}
```

The function can be trivially adjusted to match filenames with bare numbers (eg `2.md`), or any other pattern (`anotherFilename1.jpg`), by altering the pattern used by the `sed` command. For example, to handle bare numbers, the line can be changed to:

```bash
NUM="$(echo "$1" | sed -n -e 's/^\([[:digit:]]\+\)\..*/\1/p')"
```

To batch-rename all the files in the current directory:

```bash
for filename in *; do
    mv "$filename" "$(zeropad "$filename")";
done
```

To pad numbers up to 7 digits:

```bash
for filename in *; do
    mv "$filename" "$(zeropad "$filename" 7)";
done
```
