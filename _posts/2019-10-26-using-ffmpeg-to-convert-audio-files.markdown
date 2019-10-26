---
layout: post
title:  "Using ffmpeg to convert audio files"
date:   2019-10-26
tags: linux macos bash scripting
categories: snips
---

Recently, I needed to convert some `.wav` and `.ogg` files to `.mp3`, so I ended up using `ffmpeg`, a Swiss-army knife for handling different media formats from the command line.

`ffmpeg` is quite a multi-faceted tool, supporting conversion between most video and audio formats.
To enumerate some of its many abilities: it can be used to convert audio files to a new codec, extract images or audio from a video, change the resolution of a video, or crop audio (or video files) into sections.

### Installing `ffmpeg`

`ffmpeg` supports a number of different POSIX systems, but I'll cover the two I've installed it on.

On Ubuntu-based Linux systems, you can install it from the `universe` repository.
First, you'll need to make sure the `universe` repository is enabled:
```bash
sudo add-apt-repository universe
sudo apt update
sudo apt install ffmpeg
```

On macOS-based systems, you can use Homebrew to install `ffmpeg`.
If you haven't installed many packages before with `brew`, there will likely be a lot of prerequisites that need to be installed, so expect for this command to run for a while:
```bash
brew install ffmpeg
```

### Using `ffmpeg`
To actually use `ffmpeg`, you'll want to first check information on your input files with `ffmpeg -i filename01.ogg`.

A single conversion between `.ogg` and `.mp3` looks like this:
```bash
ffmpeg -i filename01.ogg filename01.mp3
```

We can write a function that will handle generating the output name for us:
```bash
ogg2mp3() {
    # Convert a .ogg file to .mp3 using ffmpeg
    INPUT_FILENAME="$1"
    OUTPUT_FILENAME="${INPUT_FILENAME/.ogg/.mp3}"
    ffmpeg -i "$INPUT_FILENAME" "$OUTPUT_FILENAME"
}

wav2mp3() {
    # Convert a .wav file to .mp3 using ffmpeg
    INPUT_FILENAME="$1"
    OUTPUT_FILENAME="${INPUT_FILENAME/.wav/.mp3}"
    ffmpeg -i "$INPUT_FILENAME" "$OUTPUT_FILENAME"
}
```

To batch rename the files:

```bash
for audiofile in *.ogg; do
    ogg2mp3 "$audiofile"
done

for audiofile in *.wav; do
    wav2mp3 "$audiofile"
done
```
