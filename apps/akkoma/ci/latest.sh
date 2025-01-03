#!/usr/bin/env bash

# Fetch the latest tag from the AkkomaGang/akkoma repository on akkoma.dev
latest_tag=$(curl -s "https://akkoma.dev/api/v1/repos/AkkomaGang/akkoma/tags" | jq --raw-output '.[0].name')

# Print the latest tag
printf "%s\n" "${latest_tag}"