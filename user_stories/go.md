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

## Try it out

First, setup the developer environment by running <code>direnv allow</code> and follow any prompts.
This ensures that tools we call in the following steps will be on the PATH.

~~~sh
direnv allow .
~~~

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

## Using protobuf and gRPC

Let's introduce a small data schema.

~~~sh
>cowsay/foo.proto cat <<EOF
syntax = "proto3";
option go_package = "example.com/bazel-starters/go-example";
message Foo {
    string message = 1;
}
EOF
~~~

Overwrite `cowsay/cmd/hello/main.go` to use the generated `Foo` message:

~~~sh
>cowsay/cmd/hello/main.go cat <<EOF
package main

import (
	"net/http"
	"nmyk.io/cowsay"
	example "example.com/bazel-starters/go-example/cowsay/foo_go_proto"
)

func main() {
	http.HandleFunc("/", HelloServer)
	http.ListenAndServe(":8080", nil)
}

func HelloServer(w http.ResponseWriter, r *http.Request) {
	foo := &example.Foo{
		Message: "Hello from Go Protobuf!",
	}
	cowsay.Cow{}.Write(w, []byte(foo.Message), false)
}
EOF
~~~

Generate the BUILD rules for protobuf and update deps of the application:

~~~sh
bazel run gazelle
~~~

Run the application again:

~~~sh
bazel run cowsay/cmd/hello &
# Wait for the server
while ! nc -z localhost 8080; do   
  sleep 0.5
done

output=$(curl localhost:8080)

echo "${output}" | grep -q "Hello from Go Protobuf" || {
    echo >&2 "Wanted output containing 'Hello from Go Protobuf' but got '${output}'"
    exit 1
}
~~~