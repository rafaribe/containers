#!/usr/bin/env bash
version=$(curl -fsSL "https://lidarr.servarr.com/v1/update/plugins/changes?os=linuxmusl&runtime=netcore&arch=x64" | jq -r '.[0].version' 2>/dev/null)
version="${version#*v}"
printf "%s" "${version}"
