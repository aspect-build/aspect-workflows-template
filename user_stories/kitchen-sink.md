# Polyglot Bazel Starter


    # This is executable Markdown that's tested on CI.
    set -o errexit -o nounset -o xtrace
    alias ~~~=":<<'~~~sh'";:<<'~~~sh'

This repo includes:
- 🧱 Latest version of Bazel and dependencies
- 📦 Curated bazelrc flags via [bazelrc-preset.bzl]
- 🧰 Developer environment setup with [bazel_env.bzl]
- 🎨 Formatting and Linting using rules_lint
- ✅ Pre-commit hooks for automatic linting and formatting


## Developer environment

Many commands are available on the PATH thanks to direnv:

~~~sh
copier --help
yq --help
~~~
