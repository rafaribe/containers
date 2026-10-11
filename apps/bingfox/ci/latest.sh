#!/usr/bin/env bash
# Bingfox has no semver releases — track the short SHA of the latest commit on main
version="$(curl -sX GET "https://api.github.com/repos/Radiotechniman/Bingfox/commits/main" \
    | jq --raw-output '.sha' 2>/dev/null | cut -c1-7)"
printf "%s" "${version}"
