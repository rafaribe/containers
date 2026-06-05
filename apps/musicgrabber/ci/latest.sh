#!/usr/bin/env bash
version="$(curl -sX GET "https://registry.hub.docker.com/v2/repositories/g33kphr33k/musicgrabber/tags?page_size=25&ordering=last_updated" | jq --raw-output '.results[].name' | grep -E '^[0-9]+\.[0-9]+' | sort -V | tail -1)"
printf "%s" "${version}"
