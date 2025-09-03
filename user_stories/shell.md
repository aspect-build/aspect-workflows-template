# Shell Bazel Starter

    alias ~~~=":<<'~~~sh'";:<<'~~~sh'

# Verify that the templated Bazel repository works with the 'shell' preset.
set -o errexit -o pipefail -o nounset

# Write a simple Bash executable
>hello.sh echo -e '#!/usr/bin/env bash\necho "Hello from Bash"'
chmod u+x hello.sh

# Generate BUILD files, see .aspect/cli/shell.star for the logic used
bazel run gazelle || true

# Verify that running the Bash program produces the expected output
# FIXME: wire up orion
# output="$(bazel run :hello)"
# [[ "${output}" == "Hello from Bash" ]] || {
#     echo >&2 "Wanted output 'Hello from Bash' but got '${output}'"
#     exit 1
# }
