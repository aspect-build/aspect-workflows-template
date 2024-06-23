#!/usr/bin/env bash
# After adding a new third-party dependency, developers should run this script.
set -o errexit -o nounset -o pipefail

{{ if .Computed.python -}}
aspect run //requirements:runtime.update
aspect run //requirements:requirements.all.update
aspect run //:gazelle_python_manifest.update
{{- end }}
aspect configure
