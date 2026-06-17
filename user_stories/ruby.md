# Ruby Bazel Starter

    # This is executable Markdown that's tested on CI.
    # How is that possible? See https://gist.github.com/bwoods/1c25cb7723a06a076c2152a2781d4d49
    set -o errexit -o nounset -o xtrace
    alias ~~~=":<<'~~~sh'";:<<'~~~sh'

This repo includes:
- 🧱 Latest version of Bazel and dependencies
- 📦 Curated bazelrc flags via [bazelrc-preset.bzl]
- 🧰 Developer environment setup with [bazel_env.bzl]
- 🎨 `rubocop` and `standard`, using rules_lint

[bazelrc-preset.bzl]: https://github.com/bazel-contrib/bazelrc-preset.bzl
[bazel_env.bzl]: https://github.com/buildbuddy-io/bazel_env.bzl

> [!NOTE]
> This project was generated from the `ruby` preset. You can create your own with
> `aspect init --preset ruby`, or start from this repo with GitHub's
> "Use this template" button. See https://aspect.build/docs/cli/overview

## Setup dev environment

First, we recommend you setup a Bazel-based developer environment with direnv.

1. install https://direnv.net/docs/installation.html
1. run <code>direnv allow</code> and follow the prompts to <code>bazel run //tools:bazel_env</code>

This isn't strictly required, but the commands which follow assume that needed tools are on the PATH,
so skipping `direnv` means you're responsible for installing them yourself.

## Build and test the sample

The starter ships a tiny `hello/ruby` package. Build it, test it, and run it:

~~~sh
aspect build --task-key build-ruby-story --github-status-comments:enabled=false --github-status-checks:enabled=false //hello/ruby:hello
aspect test --task-key test-ruby-story --github-status-comments:enabled=false --github-status-checks:enabled=false //hello/ruby:hello_test
output=$(bazel run //hello/ruby:hello)
echo "${output}" | grep -q "Hello, world!" || {
    echo >&2 "Wanted output containing 'Hello, world!' but got '${output}'"
    exit 1
}
~~~

## Add your own code

Write a simple Ruby application:

~~~sh
mkdir -p app
>app/greet.rb cat <<'EOF'
# frozen_string_literal: true

puts 'Greetings from Bazel + Ruby!'
EOF
~~~

There isn't a Gazelle extension for Ruby yet, so write a `BUILD` file by hand
using the `rb_binary` and `rb_test` rules from `@rules_ruby`:

~~~sh
>app/BUILD cat <<'EOF'
load("@rules_ruby//ruby:defs.bzl", "rb_binary")

rb_binary(
    name = "greet",
    srcs = ["greet.rb"],
    main = "greet.rb",
)
EOF
~~~

Build and run it to see the result:

~~~sh
aspect build --task-key build-ruby-greet --github-status-comments:enabled=false --github-status-checks:enabled=false //app:greet
output=$(bazel run //app:greet)
echo "${output}" | grep -q "Greetings from Bazel + Ruby!" || {
    echo >&2 "Wanted output containing 'Greetings from Bazel + Ruby!' but got '${output}'"
    exit 1
}
~~~
