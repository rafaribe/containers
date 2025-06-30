#!/usr/bin/env bash

# Fetch the latest v4.x release from netbox-community/netbox
latest_version=$(curl -sL "https://api.github.com/repos/netbox-community/netbox/releases" | \
    jq -r '.[] | select(.prerelease == false) | .tag_name' | \
    grep '^v4\.' | \
    head -1)

if [[ -n "${latest_version}" ]]; then
    printf "%s" "${latest_version}"
else
    exit 1
fi
