# Kotlin Starter

    # This is executable Markdown that's tested on CI.
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

## Try it out

> Before following these instructions, setup the developer environment by running <code>direnv allow</code> and follow any prompts.
> This ensures that tools we call in the following steps will be on the PATH.

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