#!/usr/bin/env bash
version="$(curl -sX GET "https://api.github.com/repos/clusterzx/paperless-ai/releases/latest" | jq --raw-output '.tag_name' 2>/dev/null)"
version="${version#*v}"
version="${version#*release-}"
printf "%s" "${version}"
