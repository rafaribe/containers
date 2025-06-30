#!/usr/bin/env bash
version=$(curl -sL "https://api.github.com/repos/netbox-community/netbox/releases" | \
    jq -r '.[] | select(.prerelease == false) | .tag_name' | \
    grep '^v4\.' | \
    head -1)
printf "%s" "${version}"
