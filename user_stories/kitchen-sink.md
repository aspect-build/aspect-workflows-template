# Polyglot Bazel Starter

    # This is executable Markdown that's tested on CI.
    # How is that possible? See https://gist.github.com/bwoods/1c25cb7723a06a076c2152a2781d4d49
    set -o errexit -o nounset -o xtrace
    alias ~~~=":<<'~~~sh'";:<<'~~~sh'

This repo includes:
- 🧱 Latest version of Bazel and dependencies
- 📦 Curated bazelrc flags via [bazelrc-preset.bzl]
- 🧰 Developer environment setup with [bazel_env.bzl]
- 🎨 Formatting and Linting using rules_lint

[bazelrc-preset.bzl]: https://github.com/bazel-contrib/bazelrc-preset.bzl
[bazel_env.bzl]: https://github.com/buildbuddy-io/bazel_env.bzl

> [!NOTE]
> This project was generated from the `kitchen-sink` preset. You can create your own with
> `aspect init --preset kitchen-sink`, or start from this repo with GitHub's
> "Use this template" button. See https://aspect.build/docs/cli/overview

## Setup dev environment

First, we recommend you setup a Bazel-based developer environment with direnv.

1. install https://direnv.net/docs/installation.html
1. run <code>direnv allow</code> and follow the prompts to <code>bazel run //tools:bazel_env</code>

This isn't strictly required, but the commands which follow assume that needed tools are on the PATH,
so skipping `direnv` means you're responsible for installing them yourself.

## Build and test the sample

The `kitchen-sink` preset enables every supported language, and ships a tiny
`hello/<lang>` package for each one. Prove the whole polyglot repo builds and
tests green:

~~~sh
aspect build --task:name build-kitchen-sink-story --github-status-comments:enabled=false --github-status-checks:enabled=false //...
aspect test --task:name test-kitchen-sink-story --github-status-comments:enabled=false --github-status-checks:enabled=false //...
~~~

## Run a couple of the samples

Each `hello/<lang>:hello` binary prints the same greeting. Run a few of them:

~~~sh
for lang in shell go ruby; do
    output=$(bazel run //hello/${lang}:hello)
    echo "${output}" | grep -q "Hello, world!" || {
        echo >&2 "hello/${lang}: wanted 'Hello, world!' but got '${output}'"
        exit 1
    }
done
~~~

From here, see the per-language user stories (`go.md`, `ruby.md`, `shell.md`, …)
for how to add your own code in each language.
