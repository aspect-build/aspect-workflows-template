# Rust Bazel Starter

    # This is executable Markdown that's tested on CI.
    # How is that possible? See https://gist.github.com/bwoods/1c25cb7723a06a076c2152a2781d4d49
    set -o errexit -o nounset -o xtrace
    alias ~~~=":<<'~~~sh'";:<<'~~~sh'

This repo includes:
- 🧱 Latest version of Bazel and dependencies
- 📦 Curated bazelrc flags via [bazelrc-preset.bzl]
- 🧰 Developer environment setup with [bazel_env.bzl]
- 🎨 `rustfmt` formatting, using rules_lint
- 📚 Cargo package manager integration

[bazelrc-preset.bzl]: https://github.com/bazel-contrib/bazelrc-preset.bzl
[bazel_env.bzl]: https://github.com/buildbuddy-io/bazel_env.bzl

> [!NOTE]
> This project was generated from the `rust` preset. You can create your own with
> `aspect init --preset rust`, or start from this repo with GitHub's
> "Use this template" button. See https://aspect.build/docs/cli/overview

## Setup dev environment

First, we recommend you setup a Bazel-based developer environment with direnv.

1. install https://direnv.net/docs/installation.html
1. run <code>direnv allow</code> and follow the prompts to <code>bazel run //tools:bazel_env</code>

This isn't strictly required, but the commands which follow assume that needed tools are on the PATH,
so skipping `direnv` means you're responsible for installing them yourself.

## Build and test the sample

The starter ships a tiny `hello/rust` package. Build it, test it, and run it:

~~~sh
aspect build --task:name build-rust-story --github-status-comments:enabled=false --github-status-checks:enabled=false //hello/rust:hello
aspect test --task:name test-rust-story --github-status-comments:enabled=false --github-status-checks:enabled=false //hello/rust:hello_test
output=$(bazel run //hello/rust:hello)
echo "${output}" | grep -q "Hello, world!" || {
    echo >&2 "Wanted output containing 'Hello, world!' but got '${output}'"
    exit 1
}
~~~

## Add your own code

Rust has no BUILD file generator in this starter, so create a new package with a
hand-written `BUILD` following the same `rust_binary` pattern as the sample:

~~~sh
mkdir -p src/greet
>src/greet/main.rs cat <<'EOF'
fn main() {
    println!("Greetings from Bazel");
}
EOF
>src/greet/BUILD cat <<'EOF'
load("@rules_rust//rust:defs.bzl", "rust_binary")

rust_binary(
    name = "greet",
    srcs = ["main.rs"],
    edition = "2021",
    visibility = ["//visibility:public"],
)
EOF
~~~

Build and run the new command:

~~~sh
aspect build --task:name build-rust-greet --github-status-comments:enabled=false --github-status-checks:enabled=false //src/greet:greet
output=$(bazel run //src/greet:greet)
echo "${output}" | grep -q "Greetings from Bazel" || {
    echo >&2 "Wanted output containing 'Greetings from Bazel' but got '${output}'"
    exit 1
}
~~~
