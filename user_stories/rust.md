# Rust Bazel Starter

    # This is executable Markdown that's tested on CI.
    # How is that possible? See https://gist.github.com/bwoods/1c25cb7723a06a076c2152a2781d4d49
    set -o errexit -o nounset -o xtrace
    alias ~~~=":<<'~~~sh'";:<<'~~~sh'

This repo includes:
- 🧱 Latest version of Bazel and dependencies
- 📦 Curated bazelrc flags via [bazelrc-preset.bzl]
- 🧰 Developer environment setup with [bazel_env.bzl]
- 🎨 `rustfmt`, using rules_lint
- ✅ Pre-commit hooks for automatic linting and formatting
- 📚 Cargo package manager integration

## Try it out

> Before following these instructions, setup the developer environment by running <code>direnv allow</code> and follow any prompts.
> This ensures that tools we call in the following steps will be on the PATH.

First we create a tiny Rust program

~~~sh
mkdir -p hello_world/src
cat >hello_world/src/main.rs <<EOF
fn main() { println!("Hello from Rust"); }
EOF
~~~

We don't have any BUILD file generation for Rust yet,
so you're forced to create it manually.

~~~sh
touch hello_world/BUILD
buildozer 'new_load @rules_rust//rust:defs.bzl rust_binary' hello_world:__pkg__
buildozer 'new rust_binary hello_world' hello_world:__pkg__
buildozer 'add srcs src/main.rs' hello_world:hello_world
~~~

Now you can run the program and assert that it produces the expected output.

~~~sh
output="$(bazel run hello_world)"

[ "${output}" = "Hello from Rust" ] || {
    echo >&2 "Wanted output 'Hello from Rust' but got '${output}'"
    exit 1
}
~~~

## Formatting

We can format the code with rustfmt. Let's create some intentionally poorly formatted code:

~~~sh
cat >hello_world/src/main.rs <<EOF
fn main(){
println!("Hello from Rust");
}
EOF
~~~

Now format it:

~~~sh
aspect format
~~~

Let's verify the code was properly formatted:

~~~sh
cat hello_world/src/main.rs
# -> fn main() {
# ->     println!("Hello from Rust");
# -> }
~~~

<!--
~~~sh
formatted=$(cat hello_world/src/main.rs)
echo "${formatted}" | grep -q "^fn main() {$" && \
echo "${formatted}" | grep -q "^    println!(\"Hello from Rust\");$" && \
echo "${formatted}" | grep -q "^}$" || {
    echo >&2 "Code was not properly formatted. Got:"
    echo >&2 "${formatted}"
    exit 1
}
~~~
-->
