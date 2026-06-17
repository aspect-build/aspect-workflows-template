# C/C++ Bazel Starter

    # This is executable Markdown that's tested on CI.
    # How is that possible? See https://gist.github.com/bwoods/1c25cb7723a06a076c2152a2781d4d49
    set -o errexit -o nounset -o xtrace
    alias ~~~=":<<'~~~sh'";:<<'~~~sh'

This repo includes:
- 🧱 Latest version of Bazel and dependencies
- 📦 Curated bazelrc flags via [bazelrc-preset.bzl]
- 🧰 Developer environment setup with [bazel_env.bzl]
- 🎨 `clang-format` and `clang-tidy`, using rules_lint

[bazelrc-preset.bzl]: https://github.com/bazel-contrib/bazelrc-preset.bzl
[bazel_env.bzl]: https://github.com/buildbuddy-io/bazel_env.bzl

> [!NOTE]
> This project was generated from the `cpp` preset. You can create your own with
> `aspect init --preset cpp`, or start from this repo with GitHub's
> "Use this template" button. See https://aspect.build/docs/cli/overview

## Setup dev environment

First, we recommend you setup a Bazel-based developer environment with direnv.

1. install https://direnv.net/docs/installation.html
1. run <code>direnv allow</code> and follow the prompts to <code>bazel run //tools:bazel_env</code>

This isn't strictly required, but the commands which follow assume that needed tools are on the PATH,
so skipping `direnv` means you're responsible for installing them yourself.

## Build and test the sample

The starter ships a tiny `hello/cpp` package. Build it, test it, and run it:

~~~sh
aspect build --task-key build-cpp-story --github-status-comments:enabled=false --github-status-checks:enabled=false //hello/cpp:main
aspect test --task-key test-cpp-story --github-status-comments:enabled=false --github-status-checks:enabled=false //hello/cpp:hello_test
output=$(bazel run //hello/cpp:main)
echo "${output}" | grep -q "Hello, world!" || {
    echo >&2 "Wanted output containing 'Hello, world!' but got '${output}'"
    exit 1
}
~~~

## Add your own code

C/C++ has no BUILD file generator in this starter, so create a new package with a
hand-written `BUILD` following the same `cc_binary` pattern as the sample:

~~~sh
mkdir -p src/greet
>src/greet/main.cc cat <<'EOF'
#include <iostream>

int main() {
  std::cout << "Greetings from Bazel" << '\n';
  return 0;
}
EOF
>src/greet/BUILD cat <<'EOF'
load("@rules_cc//cc:defs.bzl", "cc_binary")

cc_binary(
    name = "greet",
    srcs = ["main.cc"],
    visibility = ["//visibility:public"],
)
EOF
~~~

Build and run the new command:

~~~sh
aspect build --task-key build-cpp-greet --github-status-comments:enabled=false --github-status-checks:enabled=false //src/greet:greet
output=$(bazel run //src/greet:greet)
echo "${output}" | grep -q "Greetings from Bazel" || {
    echo >&2 "Wanted output containing 'Greetings from Bazel' but got '${output}'"
    exit 1
}
~~~
