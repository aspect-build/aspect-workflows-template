# JavaScript / TypeScript Bazel Starter

    # This is executable Markdown that's tested on CI.
    # How is that possible? See https://gist.github.com/bwoods/1c25cb7723a06a076c2152a2781d4d49
    set -o errexit -o nounset -o xtrace
    alias ~~~=":<<'~~~sh'";:<<'~~~sh'

This repo includes:
- 🧱 Latest version of Bazel and dependencies
- 📦 Curated bazelrc flags via [bazelrc-preset.bzl]
- 🧰 Developer environment setup with [bazel_env.bzl]
- 🎨 `prettier` and `eslint`, using rules_lint
- ✅ Pre-commit hooks for automatic linting and formatting
- 📚 PNPM package manager integration

> [!NOTE]
> You can customize languages and features with the interactive wizard in the <code>aspect init</code> command.
> <code>init</code> is an alternative to this starter repo, which was generated using the 'js' preset.
> See https://docs.aspect.build/cli/overview

## Setup dev environment

First, we recommend you setup a Bazel-based developer environment with direnv.

1. install https://direnv.net/docs/installation.html
1. run <code>direnv allow</code> and follow the prompts to <code>bazel run //tools:bazel_env</code>

This isn't strictly required, but the commands which follow assume that needed tools are on the PATH,
so skipping `direnv` means you're responsible for installing them yourself.

## Try it out

The Bazel-managed version of pnpm is on the PATH thanks to direnv:

~~~sh
which pnpm
# -> bazel-out/bazel_env-opt/bin/tools/bazel_env/bin/pnpm
pnpm list
~~~

## Node.js program

The repo already contains a pnpm workspace.
Let's add a new package to it, which will use the `chalk` npm dependency.

~~~sh
mkdir -p packages/hello
cd packages/hello
pnpm init
pnpm pkg set type=module
pnpm add chalk
~~~

Now create a tiny Node.js program:

~~~sh
>index.js cat <<EOF
import chalk from 'chalk';
console.log(chalk.green('Hello World!'));
EOF
~~~

Observe that the program already works outside Bazel:

~~~sh
pnpm pkg set scripts.hello="node index.js"
pnpm run hello
# -> Hello World!
~~~

Running our program under Bazel is easy, we just need `BUILD` files, which can be generated with the Gazelle tool.

~~~sh
bazel run //:gazelle
bazel run //packages/hello
# -> Hello World!
~~~

## Code generation

We can use Yeoman to scaffold out a library and add its dependencies:

~~~sh
pnpm add -w generator-bazel-fastify-route
yo bazel-fastify-route
~~~

## Linting

ESLint is already setup in the repo. Bazel doesn't have a lint command, so we use the Aspect CLI:

~~~sh
aspect lint
~~~
