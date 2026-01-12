# Java Bazel Starter

    # This is executable Markdown that's tested on CI.
    # How is that possible? See https://gist.github.com/bwoods/1c25cb7723a06a076c2152a2781d4d49
    set -o errexit -o nounset -o xtrace
    alias ~~~=":<<'~~~sh'";:<<'~~~sh'

This repo includes:
- 🧱 Latest version of Bazel and dependencies
- 📦 Curated bazelrc flags via [bazelrc-preset.bzl]
- 🧰 Developer environment setup with [bazel_env.bzl]
- 🎨 `google-java-format` and `pmd`/`checkstyle`, using rules_lint
- ✅ Pre-commit hooks for automatic linting and formatting
- 📚 Maven package manager integration

## Try it out

First, setup the developer environment by running <code>direnv allow</code> and follow any prompts.
This ensures that tools we call in the following steps will be on the PATH.

~~~sh
direnv allow .
~~~

Create a minimal Java application:

~~~sh
mkdir src
>src/Demo.java cat <<EOF
class Demo {
    public static void main(String[] args) {
        System.out.println("Hello from Java");
    }
}
EOF
~~~

We didn't wire up the BUILD file generator for Java yet, so users
are forced to write this manually.

~~~sh
touch src/BUILD
buildozer 'new_load @rules_java//java:java_binary.bzl java_binary' src:__pkg__
buildozer 'new java_binary Demo' src:__pkg__
buildozer 'add srcs Demo.java' src:Demo
~~~

Now the application should run, and we can verify it produced the expected output:

~~~sh
output="$(bazel run src:Demo)"

[ "${output}" = "Hello from Java" ] || {
    echo >&2 "Wanted output 'Hello from Java' but got '${output}'"
    exit 1
}
~~~

### Linting

Run <code>aspect lint</code>, a task in Aspect CLI.
This is configured to run PMD by default, though you could run other tools.

~~~sh
aspect lint //...
~~~

<code>
INFO: Build completed successfully, 3 total actions
Lint results for //src:Demo:

Summary:

* warnings: 0
</code>

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

There isn't a Gazelle generator for java_proto_library yet, so add it manually:

~~~sh
buildozer 'new_load @protobuf//bazel:java_proto_library.bzl java_proto_library' src:__pkg__
buildozer 'new java_proto_library foo_java_proto' src:__pkg__
buildozer 'add deps :foo_proto' src:foo_java_proto
buildozer 'add deps :foo_java_proto' src:Demo
~~~

Now overwrite `Demo.java` to use the generated `Foo` message:

~~~sh
>src/Demo.java cat <<EOF
import build.aspect.examples.FooOuterClass;
class Demo {
    public static void main(String[] args) {
        FooOuterClass.Foo foo = FooOuterClass.Foo.newBuilder()
            .setMessage("Hello from Java Protobuf!")
            .build();
        System.out.println(foo);
    }
}
EOF
~~~

Run the application again:

~~~sh
output="$(bazel run src:Demo)"

[ "${output}" = "message: \"Hello from Java Protobuf!\"" ] || {
    echo >&2 "Wanted output 'Hello from Java Protobuf' but got '${output}'"
    exit 1
}
~~~