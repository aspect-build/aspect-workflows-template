#!/usr/bin/env bash
# Runs hello.sh and verifies its greeting output.
set -o errexit -o nounset -o pipefail

hello="$(dirname "${BASH_SOURCE[0]}")/hello.sh"

actual="$("${hello}" Bazel)"
expected="Hello, Bazel!"

if [[ "${actual}" != "${expected}" ]]; then
	printf 'FAIL: got %q, want %q\n' "${actual}" "${expected}" >&2
	exit 1
fi

printf 'PASS\n'
