#!/usr/bin/env bash

set -o errexit -o pipefail -o nounset

tmp="$(mktemp -d)" 

if ! scaffold --output-dir="$tmp" new --preset="go" --no-prompt $(pwd); then 
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
