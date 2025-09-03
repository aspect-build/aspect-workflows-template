# C/C++ Bazel Starter

    # This is executable Markdown that's tested on CI.
    set -o errexit -o nounset -o xtrace
    alias ~~~=":<<'~~~sh'";:<<'~~~sh'

This repo includes:
- 🧱 Latest version of Bazel and dependencies
- 📦 Curated bazelrc flags via [bazelrc-preset.bzl]
- 🧰 Developer environment setup with [bazel_env.bzl]
- 🎨 `clang-format` and `clang-tidy`, using rules_lint
- ✅ Pre-commit hooks for automatic linting and formatting

Example user workflows 

**TODO(alex): create a cc_binary and run it**
