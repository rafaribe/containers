#!/usr/bin/env bash
version="$(curl -sX GET "https://api.github.com/repos/MrMartiniMo/docmost-mcp/releases/latest" | jq --raw-output '.tag_name' 2>/dev/null)"
version="${version#*v}"
printf "%s" "${version}"
