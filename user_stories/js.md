# JavaScript / TypeScript Bazel Starter

    # This is executable Markdown that's tested on CI.
    set -o errexit -o nounset -o xtrace
    alias ~~~=":<<'~~~sh'";:<<'~~~sh'

This repo includes:
- 🧱 Latest version of Bazel and dependencies
- 📦 Curated bazelrc flags via [bazelrc-preset.bzl]
- 🧰 Developer environment setup with [bazel_env.bzl]
- 🎨 `prettier` and `eslint`, using rules_lint
- ✅ Pre-commit hooks for automatic linting and formatting
- 📚 PNPM package manager integration

## Developer tools

> Before following these instructions, setup the developer environment by running <code>direnv allow</code> and follow any prompts.
> This ensures that tools we call in the following steps will be on the PATH.

The Bazel-managed version of pnpm is on the PATH thanks to direnv:

~~~sh
pnpm list
~~~

We can use Yeoman to scaffold out a library and add its dependencies:

~~~sh
pnpm add -w generator-bazel-fastify-route
yo bazel-fastify-route
~~~
