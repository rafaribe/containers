#!/usr/bin/env bash

# Fetch the tags from the GitHub repository and sort by commit date
TAGS=$(curl -sX GET "https://api.github.com/repos/bluesky-social/pds/tags" | jq -r '.[] | .name + " " + .commit.sha' | while read -r tag sha; do
    echo "Tag: $tag, SHA: $sha"
    date=$(curl -sX GET "https://api.github.com/repos/bluesky-social/pds/commits/${sha}" | jq -r '.commit.committer.date')
    echo "$date $tag"
done | sort -r | awk '{print $2}')

# Filter tags to only include valid semantic versioning tags
SEMVER_TAGS=$(echo "${TAGS}" | grep -E '^v?[0-9]+\.[0-9]+\.[0-9]+$')

# Get the latest semver tag
LATEST_TAG=$(echo "${SEMVER_TAGS}" | head -n 1)

# Optionally remove the 'v' prefix
LATEST_TAG_NO_V=$(echo "${LATEST_TAG}" | sed 's/^v//')

# Output the latest tag
printf "%s" "${LATEST_TAG_NO_V}"