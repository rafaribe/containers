#!/usr/bin/env bash
channel=$1

if [[ "${channel}" == "stable" ]]; then
    # Picard 3.x uses PyQt6; 2.x uses PyQt5 (incompatible with Alpine 3.24+)
    version=$(curl -sL "https://pypi.org/pypi/picard/json" | jq -r '.releases | keys[] | select(startswith("3."))' | sort -V | tail -1 2>/dev/null)
    printf "%s" "${version}"
fi
