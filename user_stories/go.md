# Go Bazel Starter

    # This is executable Markdown that's tested on CI.
    set -o errexit -o nounset -o xtrace
    alias ~~~=":<<'~~~sh'";:<<'~~~sh'

This repo includes:
- 🧱 Latest version of Bazel and dependencies
- 📦 Curated bazelrc flags via [bazelrc-preset.bzl]
- 🧰 Developer environment setup with [bazel_env.bzl]
- ✅ Pre-commit hooks for automatic linting and formatting
- 📚 go.mod package integration

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
bazel run gazelle || true
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
