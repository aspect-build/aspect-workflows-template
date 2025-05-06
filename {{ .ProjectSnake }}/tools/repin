#!/usr/bin/env bash

# After adding a new third-party dependency, developers should run this script.
set -o errexit -o nounset -o pipefail

{{ if .Computed.python -}}
bazel run //requirements:runtime.update
bazel run //requirements:requirements.all.update
bazel run //:gazelle_python_manifest.update
{{- end }}

# configure exits 110 on success
bazel configure || true

# Workaround: aspect configure runs "native" Go extensions first,
# so we much run a second time for them to see the py_pytest_main we generate
bazel configure || true
