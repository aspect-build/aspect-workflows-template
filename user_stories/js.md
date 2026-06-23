# JavaScript / TypeScript Bazel Starter

    # This is executable Markdown that's tested on CI.
    # How is that possible? See https://gist.github.com/bwoods/1c25cb7723a06a076c2152a2781d4d49
    set -o errexit -o nounset -o xtrace
    alias ~~~=":<<'~~~sh'";:<<'~~~sh'

This repo includes:
- 🧱 Latest version of Bazel and dependencies
- 📦 Curated bazelrc flags via [bazelrc-preset.bzl]
- 🧰 Developer environment setup with [bazel_env.bzl]
- 📚 pnpm package manager integration

[bazelrc-preset.bzl]: https://github.com/bazel-contrib/bazelrc-preset.bzl
[bazel_env.bzl]: https://github.com/buildbuddy-io/bazel_env.bzl

> [!NOTE]
> This project was generated from the `js` preset. You can create your own with
> `aspect init --preset js`, or start from this repo with GitHub's
> "Use this template" button. See https://aspect.build/docs/cli/overview

## Setup dev environment

First, we recommend you setup a Bazel-based developer environment with direnv.

1. install https://direnv.net/docs/installation.html
1. run <code>direnv allow</code> and follow the prompts to <code>bazel run //tools:bazel_env</code>

This isn't strictly required, but the commands which follow assume that needed tools are on the PATH,
so skipping `direnv` means you're responsible for installing them yourself.

## Build and test the sample

The starter ships a tiny `hello/js` package. Build it, test it, and run it:

~~~sh
aspect build --task:name build-js-story --github-status-comments:enabled=false --github-status-checks:enabled=false //hello/js:hello
aspect test --task:name test-js-story --github-status-comments:enabled=false --github-status-checks:enabled=false //hello/js:hello_test
output=$(bazel run //hello/js:hello)
echo "${output}" | grep -q "Hello, world!" || {
    echo >&2 "Wanted output containing 'Hello, world!' but got '${output}'"
    exit 1
}
~~~

## Add your own code

Create a new package with a `main`. TypeScript packages need a `tsconfig.json`,
so create one alongside the source:

~~~sh
mkdir -p cmd/greet
>cmd/greet/main.ts cat <<'EOF'
console.log("Greetings from Bazel");
EOF
>cmd/greet/tsconfig.json cat <<'EOF'
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "NodeNext",
    "moduleResolution": "NodeNext",
    "declaration": true,
    "strict": true
  }
}
EOF
~~~

Now write a `BUILD.bazel`. A `ts_config` points at the `tsconfig.json`, a
`ts_project` compiles the TypeScript, and a `js_binary` runs the compiled
output (mirroring `hello/js/BUILD.bazel`):

~~~sh
>cmd/greet/BUILD.bazel cat <<'EOF'
load("@aspect_rules_js//js:defs.bzl", "js_binary")
load("@aspect_rules_swc//swc:defs.bzl", "swc")
load("@aspect_rules_ts//ts:defs.bzl", "ts_config", "ts_project")

ts_config(
    name = "tsconfig",
    src = "tsconfig.json",
)

ts_project(
    name = "greet",
    srcs = ["main.ts"],
    declaration = True,
    transpiler = swc,
    tsconfig = ":tsconfig",
)

js_binary(
    name = "main",
    data = [":greet"],
    entry_point = "main.js",
)
EOF
~~~

Build and run the new command:

~~~sh
aspect build --task:name build-js-greet --github-status-comments:enabled=false --github-status-checks:enabled=false //cmd/greet:main
output=$(bazel run //cmd/greet:main)
echo "${output}" | grep -q "Greetings from Bazel" || {
    echo >&2 "Wanted output containing 'Greetings from Bazel' but got '${output}'"
    exit 1
}
~~~
