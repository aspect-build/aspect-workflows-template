# Go Bazel Starter

    # This is executable Markdown that's tested on CI.
    # How is that possible? See https://gist.github.com/bwoods/1c25cb7723a06a076c2152a2781d4d49
    set -o errexit -o nounset -o xtrace
    alias ~~~=":<<'~~~sh'";:<<'~~~sh'

This repo includes:
- 🧱 Latest version of Bazel and dependencies
- 📦 Curated bazelrc flags via [bazelrc-preset.bzl]
- 🧰 Developer environment setup with [bazel_env.bzl]
- ✅ Pre-commit hooks for automatic linting and formatting
- 📚 go.mod package integration

> [!NOTE]
> You can customize languages and features with the interactive wizard in the <code>aspect init</code> command.
> <code>init</code> is an alternative to this starter repo, which was generated using the 'go' preset.
> See https://docs.aspect.build/cli/overview

## Setup dev environment

First, we recommend you setup a Bazel-based developer environment with direnv.

1. install https://direnv.net/docs/installation.html
1. run <code>direnv allow</code> and follow the prompts to <code>bazel run //tools:bazel_env</code>

This isn't strictly required, but the commands which follow assume that needed tools are on the PATH,
so skipping `direnv` means you're responsible for installing them yourself.

## Try it out

First, run scaffold which is on the PATH thanks to direnv.
This creates a new command in the repo.

~~~sh
scaffold new https://github.com/alexeagle/cowsay-go-scaffold Project=cowsay
~~~

Next, create or update the go.mod file, including the nmyk.io/cowsay dependency pinning.
This uses the Bazel-managed go SDK.

~~~sh
go mod tidy
~~~

Now we generate BUILD files:

~~~sh
bazel run gazelle
~~~

We can see that the app builds now:

~~~sh
bazel build cowsay/cmd/hello
~~~

Let's run the application, starting a server in the background.

~~~sh
bazel run cowsay/cmd/hello &
# Wait for the server
while ! nc -z localhost 8080; do   
  sleep 0.5
done
~~~

Finally we can hit that server to verify the application output matches expectation:

~~~sh
output=$(curl localhost:8080)

echo "${output}" | grep -q "Hello, world" || {
    echo >&2 "Wanted output containing 'Hello, world' but got '${output}'"
    exit 1
}
~~~

**TODO: Build an OCI container for the target platform**
with bazel build //cmd/hello:image.load
