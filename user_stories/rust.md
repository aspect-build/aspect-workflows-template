# Rust Bazel Starter

    # This is executable Markdown that's tested on CI.
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

First we create a tiny Rust program with a third-party dependency:

~~~sh
cargo new hello_world
cat >hello_world/src/main.rs <<EOF
use rand::Rng;

fn main() {
    let num = rand::thread_rng().gen_range(1..=3);
    for _ in 0..num {
        println!("Hello from Rust");
    }
}
EOF
~~~

Add the dependency to Cargo.toml, and run `check` to update the Cargo.lock file that Bazel reads:

~~~sh
echo 'rand = "0.8"' >> hello_world/Cargo.toml
cargo check
~~~

We don't have any BUILD file generation for Rust yet,
so you're forced to create it manually.
~~~sh
touch hello_world/BUILD
buildozer 'new_load @rules_rust//rust:defs.bzl rust_binary' hello_world:__pkg__
buildozer 'new rust_binary hello_world' hello_world:__pkg__
buildozer 'add srcs src/main.rs' hello_world:hello_world
buildozer 'add deps @crates//:rand' hello_world:hello_world
~~~

Now you can run the program and assert that it produces the expected output.

~~~sh
output="$(bazel run hello_world | tail -1)"

[ "${output}" = "Hello from Rust" ] || {
    echo >&2 "Wanted output 'Hello from Rust' but got '${output}'"
    exit 1
}
~~~
