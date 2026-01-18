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

## Try it out

> Before following these instructions, setup the developer environment by running <code>direnv allow</code> and follow any prompts.
> This ensures that tools we call in the following steps will be on the PATH.

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

## Using protobuf and gRPC

Let's introduce a small data schema.

~~~sh
>src/foo.proto cat <<EOF
syntax = "proto3";
option java_package = "build.aspect.examples";
option java_outer_classname = "FooOuterClass";
message Foo {
    string message = 1;
}
EOF
~~~

Generate the BUILD rules for protobuf:

~~~sh
bazel run gazelle
~~~

There isn't a Gazelle generator for scala_proto_library yet, so add it manually:

~~~sh
buildozer 'new_load @rules_scala//scala_proto:scala_proto.bzl scala_proto_library' src:__pkg__
buildozer 'new scala_proto_library foo_scala_proto' src:__pkg__
buildozer 'add deps :foo_proto' src:foo_scala_proto
buildozer 'add deps :foo_scala_proto' src:Hello
~~~

Now overwrite `Hello.scala` to use the generated `Foo` message:

~~~sh
>src/Hello.scala cat <<EOF
import build.aspect.examples.FooOuterClass

object Hello {
  def main(args: Array[String]): Unit = {
    val foo = FooOuterClass.Foo.newBuilder()
      .setMessage("Hello from Scala Protobuf!")
      .build()
    println(foo)
  }
}
EOF
~~~

Run the application again:

~~~sh
output="$(bazel run src:Hello)"

[ "${output}" = "message: \"Hello from Scala Protobuf!\"" ] || {
    echo >&2 "Wanted output 'Hello from Scala Protobuf' but got '${output}'"
    exit 1
}
~~~