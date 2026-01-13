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
- ✅ Pre-commit hooks for automatic linting and formatting

## Try it out

First, setup the developer environment by running <code>direnv allow</code> and follow any prompts.
This ensures that tools we call in the following steps will be on the PATH.

~~~sh
direnv allow .
~~~

Write a simple Ruby application:

~~~sh
mkdir app
>app/hello.rb cat <<'EOF'
require "faker"
puts "Hello, #{Faker::Name.name} from Bazel + Ruby!"
EOF
~~~

Declare the dependency to the package manager:

~~~sh
echo 'gem "faker"' >> Gemfile
bundle config set path 'vendor/bundle'
bundle install
~~~

There isn't a Gazelle extension yet, so write a BUILD file by hand:

~~~sh
>app/BUILD cat <<EOF
load("@rules_ruby//ruby:defs.bzl", "rb_binary")

rb_binary(
    name = "hello",
    srcs = ["hello.rb"],
    main = "hello.rb",
    deps = ["@bundle"],
)
EOF
~~~

Run it to see the result:
> (Note that Bundle will spam the stdout with install information, so we just want the last line)

~~~sh
output=$(bazel run //app:hello | tail -1)
~~~

Let's verify the application output matches expectation:

~~~sh
echo "${output}" | grep -qE "^Hello, .+ from Bazel \\+ Ruby!$" || {
    echo >&2 "Wanted output matching 'Hello, <name> from Bazel + Ruby!' but got '${output}'"
    exit 1
}
~~~
