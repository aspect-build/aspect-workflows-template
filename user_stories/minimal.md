# Minimal Bazel starter with no languages

    # This is executable Markdown!
    set -o errexit
    alias ~~~=":<<'~~~sh'";:<<'~~~sh'

This repo includes:
- 🧱 Latest version of Bazel and dependencies
- 📦 Curated bazelrc flags via [bazelrc-preset.bzl]
- 🧰 Developer environment setup with [bazel_env.bzl]

We can verify that the templated Bazel repository works with no languages selected:

~~~sh
bazel build ...
~~~
