# Shell Bazel Starter

    # This is executable Markdown that's tested on CI.
    # How is that possible? See https://gist.github.com/bwoods/1c25cb7723a06a076c2152a2781d4d49
    set -o errexit -o nounset -o xtrace
    alias ~~~=":<<'~~~sh'";:<<'~~~sh'

This repo includes:
- 🧱 Latest version of Bazel and dependencies
- 📦 Curated bazelrc flags via [bazelrc-preset.bzl]
- 🧰 Developer environment setup with [bazel_env.bzl]
- 🎨 `shfmt` and `shellcheck`, using rules_lint

[bazelrc-preset.bzl]: https://github.com/bazel-contrib/bazelrc-preset.bzl
[bazel_env.bzl]: https://github.com/buildbuddy-io/bazel_env.bzl

> [!NOTE]
> This project was generated from the `shell` preset. You can create your own with
> `aspect init --preset shell`, or start from this repo with GitHub's
> "Use this template" button. See https://aspect.build/docs/cli/overview

## Setup dev environment

First, we recommend you setup a Bazel-based developer environment with direnv.

1. install https://direnv.net/docs/installation.html
1. run <code>direnv allow</code> and follow the prompts to <code>bazel run //tools:bazel_env</code>

This isn't strictly required, but the commands which follow assume that needed tools are on the PATH,
so skipping `direnv` means you're responsible for installing them yourself.

## Build and test the sample

The starter ships a tiny `hello/shell` package. Build it, test it, and run it:

~~~sh
aspect build --task-key build-shell-story --github-status-comments:enabled=false --github-status-checks:enabled=false //hello/shell:hello
aspect test --task-key test-shell-story --github-status-comments:enabled=false --github-status-checks:enabled=false //hello/shell:hello_test
output=$(bazel run //hello/shell:hello)
echo "${output}" | grep -q "Hello, world!" || {
    echo >&2 "Wanted output containing 'Hello, world!' but got '${output}'"
    exit 1
}
~~~

## Add your own code

Write a simple Bash executable (remember the `#!` shebang and the executable bit):

~~~sh
mkdir -p cmd/greet
>cmd/greet/greet.sh cat <<'EOF'
#!/usr/bin/env bash
echo "Greetings from Bazel"
EOF
chmod u+x cmd/greet/greet.sh
~~~

Declare a `sh_binary` for it in a `BUILD` file, using the rules from
`@rules_shell` (the same pattern as the shipped `hello/shell/BUILD`):

~~~sh
>cmd/greet/BUILD cat <<'EOF'
load("@rules_shell//shell:sh_binary.bzl", "sh_binary")

sh_binary(
    name = "greet",
    srcs = ["greet.sh"],
)
EOF
~~~

Build and run the new command:

~~~sh
aspect build --task-key build-shell-greet --github-status-comments:enabled=false --github-status-checks:enabled=false //cmd/greet:greet
output=$(bazel run //cmd/greet:greet)
echo "${output}" | grep -q "Greetings from Bazel" || {
    echo >&2 "Wanted output containing 'Greetings from Bazel' but got '${output}'"
    exit 1
}
~~~
