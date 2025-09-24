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

> Before following these instructions, setup the developer environment by running <code>direnv allow</code> and follow any prompts.
> This ensures that tools we call in the following steps will be on the PATH.

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

Run <code>bazel lint</code>, the command added by Aspect CLI.
This is configured to run PMD by default, though you could run other tools.

~~~sh
bazel lint //...
~~~

<code>
INFO: Build completed successfully, 3 total actions
Lint results for //src:Demo:

Summary:

* warnings: 0
</code>
