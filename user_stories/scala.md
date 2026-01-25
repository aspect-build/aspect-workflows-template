# Scala Bazel Starter

    # This is executable Markdown that's tested on CI.
    # How is that possible? See https://gist.github.com/bwoods/1c25cb7723a06a076c2152a2781d4d49
    set -o errexit -o nounset -o xtrace
    alias ~~~=":<<'~~~sh'";:<<'~~~sh'

This repo includes:
- 🧱 Latest version of Bazel and dependencies
- 📦 Curated bazelrc flags via [bazelrc-preset.bzl]
- 🧰 Developer environment setup with [bazel_env.bzl]
- ✅ Pre-commit hooks for automatic linting and formatting
- 📚 Maven package manager integration

> [!NOTE]
> You can customize languages and features with the interactive wizard in the <code>aspect init</code> command.
> <code>init</code> is an alternative to this starter repo, which was generated using the 'scala' preset.
> See https://docs.aspect.build/cli/overview

## Setup dev environment

First, we recommend you setup a Bazel-based developer environment with direnv.

1. install https://direnv.net/docs/installation.html
1. run <code>direnv allow</code> and follow the prompts to <code>bazel run //tools:bazel_env</code>

This isn't strictly required, but the commands which follow assume that needed tools are on the PATH,
so skipping `direnv` means you're responsible for installing them yourself.

## Try it out

Create a minimal Scala application:

~~~sh
mkdir src
>src/Hello.scala cat <<EOF
object Hello {
  def main(args: Array[String]): Unit = {
    println("Hello from Scala")
  }
}
EOF
~~~

We didn't wire up the BUILD file generator for Scala yet
(https://github.com/stackb/scala-gazelle)
so we'll add this manually:

~~~sh
touch src/BUILD
buildozer 'new_load @rules_scala//scala:scala.bzl scala_binary' src:__pkg__
buildozer 'new scala_binary Hello' src:__pkg__
buildozer 'add srcs Hello.scala' src:Hello
buildozer 'set main_class Hello' src:Hello
~~~

Now the application should run, and we can verify it produced the expected output:

~~~sh
output="$(bazel run src:Hello)"

[ "${output}" = "Hello from Scala" ] || {
    echo >&2 "Wanted output 'Hello from Scala' but got '${output}'"
    exit 1
}
~~~
