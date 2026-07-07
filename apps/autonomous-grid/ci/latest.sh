#!/usr/bin/env bash
version="$(curl -sL -o /dev/null -w '%{url_effective}' "https://github.com/autonomous-ai/autonomous-grid/releases/latest" | grep -oP 'v\K[^/]+')"
printf "%s" "${version}"
