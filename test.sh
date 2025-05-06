#!/usr/bin/env bash

set -o errexit -o pipefail -o nounset

tmp="$(mktemp -d)" 

if ! SCAFFOLD_SETTINGS_RUN_HOOKS=always scaffold new --output-dir="$tmp" --preset="${1:-kitchen-sink}" --no-prompt $(pwd); then
    rm -rf "$tmp"
    echo "Cleaned up ${tmp}"
    exit 1
fi


echo "Output is at $tmp"

read -rep "Delete it now? (y/n) " answer

if [[ "${answer}" != "n" ]]; then 
    rm -rf "$tmp"
    echo "Cleaned up ${tmp}"
fi
