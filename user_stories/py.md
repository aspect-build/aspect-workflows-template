# Python Bazel Starter

    # This is executable Markdown that's tested on CI.
    # How is that possible? See https://gist.github.com/bwoods/1c25cb7723a06a076c2152a2781d4d49
    set -o errexit -o nounset -o xtrace
    alias ~~~=":<<'~~~sh'";:<<'~~~sh'

This repo includes:
- 🧱 Latest version of Bazel and dependencies
- 📦 Curated bazelrc flags via [bazelrc-preset.bzl]
- 🧰 Developer environment setup with [bazel_env.bzl]
- 📚 PyPI package manager integration

[bazelrc-preset.bzl]: https://github.com/bazel-contrib/bazelrc-preset.bzl
[bazel_env.bzl]: https://github.com/buildbuddy-io/bazel_env.bzl

> [!NOTE]
> This project was generated from the `py` preset. You can create your own with
> `aspect init --preset py`, or start from this repo with GitHub's
> "Use this template" button. See https://aspect.build/docs/cli/overview

## Setup dev environment

First, we recommend you setup a Bazel-based developer environment with direnv.

1. install https://direnv.net/docs/installation.html
1. run <code>direnv allow</code> and follow the prompts to <code>bazel run //tools:bazel_env</code>

This isn't strictly required, but the commands which follow assume that needed tools are on the PATH,
so skipping `direnv` means you're responsible for installing them yourself.

## Build and test the sample

The starter ships a tiny `hello/py` package. Build and test it:

~~~sh
aspect build --task-key build-py-story //hello/py:hello
aspect test --task-key test-py-story //hello/py:hello_test
~~~

## Add your own code

Create a new package with a `main` and a hand-written `BUILD.bazel`. Python
targets use [aspect_rules_py](https://github.com/aspect-build/rules_py) and are
maintained by hand (Gazelle BUILD generation for Python isn't wired in this
template):

~~~sh
mkdir -p cmd/greet
>cmd/greet/main.py cat <<'EOF'
"""Print a friendly greeting."""


def main() -> None:
    print("Greetings from Bazel")


if __name__ == "__main__":
    main()
EOF
>cmd/greet/BUILD.bazel cat <<'EOF'
load("@aspect_rules_py//py:defs.bzl", "py_binary")

py_binary(
    name = "main",
    srcs = ["main.py"],
)
EOF
~~~

Build the new command:

~~~sh
aspect build --task-key build-py-greet //cmd/greet:main
~~~
