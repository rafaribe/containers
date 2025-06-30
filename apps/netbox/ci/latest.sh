#!/usr/bin/env bash

# Function to check if a tag exists in GHCR using crane
check_tag_exists() {
    local tag=$1
    # Use crane to check if the manifest exists for this tag
    crane manifest "ghcr.io/netbox-community/netbox:${tag}" >/dev/null 2>&1
    return $?
}

# Fetch v4.x releases from netbox-community/netbox
releases=$(curl -sL "https://api.github.com/repos/netbox-community/netbox/releases" | \
    jq -r '.[] | select(.prerelease == false) | .tag_name' | \
    grep '^v4\.')

# Check each release to see if it exists in GHCR
for version in $releases; do
    if check_tag_exists "$version"; then
        printf "%s" "$version"
        exit 0
    fi
done

# If no matching tag found in GHCR
exit 1
