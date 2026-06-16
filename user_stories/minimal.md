# Minimal Bazel starter with no languages

    # This is executable Markdown that's tested on CI.
    # How is that possible? See https://gist.github.com/bwoods/1c25cb7723a06a076c2152a2781d4d49
    set -o errexit -o nounset -o xtrace
    alias ~~~=":<<'~~~sh'";:<<'~~~sh'

This repo includes:
- 🧱 Latest version of Bazel and dependencies
- 📦 Curated bazelrc flags via [bazelrc-preset.bzl]
- 🧰 Developer environment setup with [bazel_env.bzl]

[bazelrc-preset.bzl]: https://github.com/bazel-contrib/bazelrc-preset.bzl
[bazel_env.bzl]: https://github.com/buildbuddy-io/bazel_env.bzl

> [!NOTE]
> This project was generated from the `minimal` preset. You can create your own with
> `aspect init --preset minimal`, or start from this repo with GitHub's
> "Use this template" button. See https://aspect.build/docs/cli/overview

The `minimal` preset ships no languages, so there's no `hello/` sample.
We can still verify that the templated Bazel repository builds with an empty workspace:

~~~sh
bazel build //...
~~~
