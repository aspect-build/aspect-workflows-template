#!/usr/bin/env bash
# Prints a friendly greeting.
set -o errexit -o nounset -o pipefail

greeting() {
	local name="${1:-world}"
	printf 'Hello, %s!\n' "${name}"
}

greeting "${1:-world}"
