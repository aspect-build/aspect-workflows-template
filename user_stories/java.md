# Java Bazel Starter

    # This is executable Markdown that's tested on CI.
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
