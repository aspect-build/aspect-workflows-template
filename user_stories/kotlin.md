# Kotlin Starter

    # This is executable Markdown that's tested on CI.
    # How is that possible? See https://gist.github.com/bwoods/1c25cb7723a06a076c2152a2781d4d49
    set -o errexit -o nounset -o xtrace
    alias ~~~=":<<'~~~sh'";:<<'~~~sh'

This repo includes:
- 🧱 Latest version of Bazel and dependencies
- 📦 Curated bazelrc flags via [bazelrc-preset.bzl]
- 🧰 Developer environment setup with [bazel_env.bzl]
- 🎨 `ktfmt` and `ktlint`, using rules_lint
- ✅ Pre-commit hooks for automatic linting and formatting
- 📚 Maven package manager integration

[bazelrc-preset.bzl]: https://github.com/bazel-contrib/bazelrc-preset.bzl
[bazel_env.bzl]: https://github.com/buildbuddy-io/bazel_env.bzl

> [!NOTE]
> You can customize languages and features with the interactive wizard in the <code>aspect init</code> command.
> <code>init</code> is an alternative to this starter repo, which was generated using the 'kotlin' preset.
> See https://docs.aspect.build/cli/overview

## Setup dev environment

First, we recommend you setup a Bazel-based developer environment with direnv.

1. install https://direnv.net/docs/installation.html
1. run <code>direnv allow</code> and follow the prompts to <code>bazel run //tools:bazel_env</code>

This isn't strictly required, but the commands which follow assume that needed tools are on the PATH,
so skipping `direnv` means you're responsible for installing them yourself.

## Try it out

First create some Kotlin source code:

~~~sh
mkdir src
>src/Demo.kt cat <<EOF
package app

class Demo {
  companion object {
    @JvmStatic
    fun main(args: Array<String>) {
      println("Hello from Kotlin")
    }
  }
}
EOF
~~~

Then run the BUILD file generation:

~~~sh
bazel run gazelle
~~~

You can check ktlint at this point:

~~~sh
aspect lint //src:all
~~~

This doesn't include Java support yet, so we need to run a couple commands
to manually create the java_binary target:

~~~sh
buildozer 'new_load @rules_java//java:java_binary.bzl java_binary' src:__pkg__
buildozer 'new java_binary app' src:__pkg__
buildozer 'set main_class app.Demo' src:app
buildozer 'add runtime_deps :src' src:app
~~~

Now we can verify that the application runs and produces the expected output:

~~~sh
output="$(bazel run src:app)"

[ "${output}" = "Hello from Kotlin" ] || {
    echo >&2 "Wanted output 'Hello from Kotlin' but got '${output}'"
    exit 1
}
~~~

Run ktlint:

~~~sh
aspect lint
~~~
