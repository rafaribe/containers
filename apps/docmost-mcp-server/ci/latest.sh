#!/usr/bin/env bash
version="$(curl -sX GET "https://registry.npmjs.org/docmost-mcp" | jq --raw-output '."dist-tags".latest' 2>/dev/null)"
printf "%s" "${version}"
