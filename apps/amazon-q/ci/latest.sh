#!/usr/bin/env bash
# Amazon Q CLI doesn't have traditional versioning, so we use a timestamp-based approach
# This ensures we always get the latest version available
printf "%s" "$(date +%Y.%m.%d)"
