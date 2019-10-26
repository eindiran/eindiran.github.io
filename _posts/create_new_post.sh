#!/usr/bin/env bash
#===============================================================================
#
#          FILE: create_new_post.sh
#
#         USAGE: ./create_new_post.sh [-l] -t "<title>" [-c "tag 1 ... tag n"]
#                ./create_new_post.sh -h
#
#   DESCRIPTION: Creates a new titled & dated markdown file with the sketch
#                of a new post.
#
#        AUTHOR: Elliott Indiran <elliott.indiran@protonmail.com>
#       CREATED: 10/15/2019
#===============================================================================

set -Eeuo pipefail

LONG_FORM=false
POST_TITLE_RAW=""
TAGS=""
CATEGORIES=""

# Print the usage information and exit
usage() {
    printf "Usage: %s [-l] -t \"<title>\" [-c \"<tag 1> ... <tag n>\"]\n" "$0"
    exit "$1"
}

# Handle the various arguments
while getopts ":t:c:h:l" opt; do
    case "${opt}" in
        l) LONG_FORM=true           ;;
        t) POST_TITLE_RAW=${OPTARG} ;;
        c) TAGS=${OPTARG}  ;;
        h) usage 0                  ;;
        *) usage 1                  ;;
    esac
done

# Exit early if a title wasn't set
if [ -z "$POST_TITLE_RAW" ]; then
    usage 1
fi

# Add the category tag for short or long form posts
#  * Long form  --> "article" tag
#  * Short form --> "snip" tag
if [ "$LONG_FORM" = true ]; then
    CATEGORIES="article"
else
    CATEGORIES="snip"
fi

# Generate the filename
POST_TITLE="$(echo "${POST_TITLE_RAW// /-}" | tr '[:upper:]' '[:lower:]')"
POST_DATE="$(date "+%Y-%m-%d")"
POST_FILENAME="${POST_DATE}-${POST_TITLE}.markdown"

# Create the file
{
cat <<- HEADER_EOF
---
layout: post
title:  "$POST_TITLE_RAW"
date:   $POST_DATE
tags: $TAGS
categories: $CATEGORIES
---

HEADER_EOF
} > "${POST_FILENAME}"
