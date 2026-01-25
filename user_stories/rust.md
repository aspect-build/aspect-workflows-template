# Rust Bazel Starter

    # This is executable Markdown that's tested on CI.
    # How is that possible? See https://gist.github.com/bwoods/1c25cb7723a06a076c2152a2781d4d49
    set -o errexit -o nounset -o xtrace
    alias ~~~=":<<'~~~sh'";:<<'~~~sh'

This repo includes:
- 🧱 Latest version of Bazel and dependencies
- 📦 Curated bazelrc flags via [bazelrc-preset.bzl]
- 🧰 Developer environment setup with [bazel_env.bzl]
- 🎨 `rustfmt` and `clippy` using rules_lint
- ✅ Pre-commit hooks for automatic linting and formatting
- 📚 Cargo package manager integration

> [!NOTE]
> You can customize languages and features with the interactive wizard in the <code>aspect init</code> command.
> <code>init</code> is an alternative to this starter repo, which was generated using the 'rust' preset.
> See https://docs.aspect.build/cli/overview

## Setup dev environment

First, we recommend you setup a Bazel-based developer environment with direnv.

1. install https://direnv.net/docs/installation.html
1. run <code>direnv allow</code> and follow the prompts to <code>bazel run //tools:bazel_env</code>

This isn't strictly required, but the commands which follow assume that needed tools are on the PATH,
so skipping `direnv` means you're responsible for installing them yourself.

## Try it out

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

## Formatting

We can format the code with rustfmt. Let's create some intentionally poorly formatted code
(the indentation is wrong) and also an auto-fixable `print_literal` warning from Clippy.

~~~sh
cat >hello_world/src/main.rs <<EOF
fn main(){
println!("{}", "Hello from Rust");
}
EOF
~~~

Now format it:

~~~sh
format
~~~

And run the linter in auto-fix mode:

~~~sh
aspect lint --fix
~~~

Let's verify the code was fixed:

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
