---
layout: post
title:  "A quick and dirty Bash zeropadding function for batch-renaming files"
date:   2019-10-19
categories: bash scripting snip
---

Recently I needed to rename thousands of numbered files so that their [lexical sort order](https://en.wikipedia.org/wiki/Lexicographical_order) would match their [numeric sort order](https://en.wikipedia.org/wiki/Collation#Numerical_and_chronological_order).
The file names originally looked approximately like this: `some-name_2.xml` or `another-name_302.xml`.
With lexical sort order, the second file `some-name_2.xml` would come _after_ the 102nd file `some-name_102.xml` because the first digit of 102 (`1`) comes lexicographically before the first digit of 2 (`2`).
With numeric sort order, because the number 102 is greater than the number 2, it should come _after_ it instead.

An easy way to coerce lexical sort order into matching numerical sort order is to zeropad each number: if the largest-numbered file has `n` digits, then we will pad each number with zeros until the number portion is `n` digits long.
The number of zeroes padded onto some number `x` will be equal to `n - len(x)`, where `len` measures the length of a number in digits.

For example, suppose the largest number in a filename in your directory is `7301`: we will then want each number to be padded up to 4 digits.
Numbers in the range `0 - 9` will be padded with 3 zeros, `10 - 99` with 2 zeros, `100 - 999` with 1 zero, and `1000 - 7301` with no zeros.

* The first file, `some-name_1.xml` becomes `some-name_0001.xml`
* The 102nd file, `some-name_102.xml` becomes `some-name_0102.xml`
* The 7301st `some-name_7301.xml` doesn't change


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
