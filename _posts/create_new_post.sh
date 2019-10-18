#!/usr/bin/env bash
#===============================================================================
#
#          FILE: create_new_post.sh
#
#         USAGE: ./create_new_post.sh "<title>" [category 1, ..., category n]
#
#   DESCRIPTION: Creates a new titled & dated markdown file with the sketch
#                of a new post.
#
#        AUTHOR: Elliott Indiran <elliott.indiran@protonmail.com>
#       CREATED: 10/15/2019
#===============================================================================

set -Eeuo pipefail

POST_TITLE_RAW="$1"
shift
POST_CATEGORIES=$*
POST_TITLE="$(echo "${POST_TITLE_RAW// /-}" | tr '[:upper:]' '[:lower:]')"
POST_DATE="$(date -I)"
POST_FILENAME="${POST_DATE}-${POST_TITLE}.markdown"

{
cat <<- HEADER_EOF
---
layout: post
title:  "$POST_TITLE_RAW"
date:   $POST_DATE
categories: $POST_CATEGORIES
---

HEADER_EOF
} > "${POST_FILENAME}"
