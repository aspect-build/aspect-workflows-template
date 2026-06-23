# Go Bazel Starter

    # This is executable Markdown that's tested on CI.
    # How is that possible? See https://gist.github.com/bwoods/1c25cb7723a06a076c2152a2781d4d49
    set -o errexit -o nounset -o xtrace
    alias ~~~=":<<'~~~sh'";:<<'~~~sh'

This repo includes:
- 🧱 Latest version of Bazel and dependencies
- 📦 Curated bazelrc flags via [bazelrc-preset.bzl]
- 🧰 Developer environment setup with [bazel_env.bzl]
- 📚 go.mod package integration

[bazelrc-preset.bzl]: https://github.com/bazel-contrib/bazelrc-preset.bzl
[bazel_env.bzl]: https://github.com/buildbuddy-io/bazel_env.bzl

> [!NOTE]
> This project was generated from the `go` preset. You can create your own with
> `aspect init --preset go`, or start from this repo with GitHub's
> "Use this template" button. See https://aspect.build/docs/cli/overview

## Setup dev environment

First, we recommend you setup a Bazel-based developer environment with direnv.

1. install https://direnv.net/docs/installation.html
1. run <code>direnv allow</code> and follow the prompts to <code>bazel run //tools:bazel_env</code>

This isn't strictly required, but the commands which follow assume that needed tools are on the PATH,
so skipping `direnv` means you're responsible for installing them yourself.

## Build and test the sample

The starter ships a tiny `hello/go` package. Build it, test it, and run it:

~~~sh
aspect build --task:name build-go-story --github-status-comments:enabled=false --github-status-checks:enabled=false //hello/go:hello
aspect test --task:name test-go-story --github-status-comments:enabled=false --github-status-checks:enabled=false //hello/go:hello_test
output=$(bazel run //hello/go:hello)
echo "${output}" | grep -q "Hello, world!" || {
    echo >&2 "Wanted output containing 'Hello, world!' but got '${output}'"
    exit 1
}
~~~

## Add your own code

Create a new package with a `main`:

~~~sh
mkdir -p cmd/greet
>cmd/greet/main.go cat <<'EOF'
package main

import "fmt"

func main() {
	fmt.Println("Greetings from Bazel")
}
EOF
~~~

Generate the `BUILD` file for it with Gazelle (scoped to the new directory).
`aspect gazelle` verifies BUILD files are up to date (and fails CI if not); pass
`--check-only=false` — or run the underlying target directly — to write them:

~~~sh
bazel run //tools/gazelle:gazelle -- cmd/greet
~~~

Build and run the new command:

~~~sh
aspect build --task:name build-go-greet --github-status-comments:enabled=false --github-status-checks:enabled=false //cmd/greet:greet
output=$(bazel run //cmd/greet:greet)
echo "${output}" | grep -q "Greetings from Bazel" || {
    echo >&2 "Wanted output containing 'Greetings from Bazel' but got '${output}'"
    exit 1
}
~~~
