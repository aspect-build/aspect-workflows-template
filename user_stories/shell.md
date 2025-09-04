# Shell Bazel Starter

    # This is executable Markdown that's tested on CI.
    set -o errexit -o nounset -o xtrace
    alias ~~~=":<<'~~~sh'";:<<'~~~sh'

This repo includes:
- 🧱 Latest version of Bazel and dependencies
- 📦 Curated bazelrc flags via [bazelrc-preset.bzl]
- 🧰 Developer environment setup with [bazel_env.bzl]
- 🎨 `shfmt` and `shellcheck`, using rules_lint
- ✅ Pre-commit hooks for automatic linting and formatting

## Try it out

> Before following these instructions, setup the developer environment by running <code>direnv allow</code> and follow any prompts.
> This ensures that tools we call in the following steps will be on the PATH.

Write a simple Bash executable:

~~~sh
>hello.sh echo -e '#!/usr/bin/env bash\necho "Hello from Bash"'
chmod u+x hello.sh
~~~

We should be able to generate BUILD files, see .aspect/cli/shell.star for the logic used
bazel run gazelle || true

# Verify that running the Bash program produces the expected output
# FIXME: wire up orion
# output="$(bazel run :hello)"
# [ "${output}" = "Hello from Bash" ] || {
#     echo >&2 "Wanted output 'Hello from Bash' but got '${output}'"
#     exit 1
# }
