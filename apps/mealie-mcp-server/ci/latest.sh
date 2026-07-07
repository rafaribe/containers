#!/usr/bin/env bash
version="$(curl -sX GET "https://api.github.com/repos/gloos/mealie-mcp-server/commits/update-api-implementation" | jq --raw-output '.sha[0:7]' 2>/dev/null)"
printf "%s" "${version}"
