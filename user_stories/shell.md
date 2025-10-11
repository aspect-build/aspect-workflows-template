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
>hello.sh cat <<'EOF'
#!/usr/bin/env bash
echo "Hello from Bash"
EOF
chmod u+x hello.sh
~~~

We should be able to generate BUILD files, see .aspect/gazelle/shell.axl for the logic used

~~~sh
bazel run gazelle || true
~~~

Now we verify that running the Bash program produces the expected output.

~~~sh
output="$(bazel run :hello)"
[ "${output}" = "Hello from Bash" ] || {
    echo >&2 "Wanted output 'Hello from Bash' but got '${output}'"
    exit 1
}
~~~
