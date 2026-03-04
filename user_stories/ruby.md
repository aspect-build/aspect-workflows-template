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

> [!NOTE]
> You can customize languages and features with the interactive wizard in the <code>aspect init</code> command.
> <code>init</code> is an alternative to this starter repo, which was generated using the 'ruby' preset.
> See https://docs.aspect.build/cli/overview

## Setup dev environment

First, we recommend you setup a Bazel-based developer environment with direnv.

1. install https://direnv.net/docs/installation.html
1. run <code>direnv allow</code> and follow the prompts to <code>bazel run //tools:bazel_env</code>

This isn't strictly required, but the commands which follow assume that needed tools are on the PATH,
so skipping `direnv` means you're responsible for installing them yourself.

## Try it out

Write a simple Ruby application:

~~~sh
mkdir app
>app/hello.rb cat <<'EOF'
# frozen_string_literal: true

require 'faker'
puts "Hello, #{Faker::Name.name} from Bazel + Ruby!"
EOF
~~~

Declare the dependency to the package manager:

~~~sh
bundle config set path 'vendor/bundle'
bundle add faker
bundle lock --add-checksums --normalize-platforms
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

## Linting

We can lint the code with rubocop, by running the Aspect CLI:

~~~sh
aspect lint
~~~

## Proto & gRPC

Create the message and service definition:

~~~sh
mkdir proto
>proto/foo.proto cat <<EOF
syntax = "proto3";

package foo;
import "google/protobuf/empty.proto";

service FooService {
  rpc GetFoo(GetFooRequest) returns (GetFooResponse);
}

message GetFooRequest {
  google.protobuf.Empty empty = 1;
}

message GetFooResponse {
  string name = 1;
}
EOF
~~~

And create the BUILD file:

~~~sh
bazel run gazelle
~~~

Update the application code to start a server:

~~~sh
>app/hello.rb cat <<'EOF'
# TODO: is there a ruby runfiles helper?
runfiles_dir = ENV["RUNFILES_DIR"]
if runfiles_dir
  main_root = File.join(runfiles_dir, "_main")
  $LOAD_PATH.unshift(main_root) if Dir.exist?(main_root) && !$LOAD_PATH.include?(main_root)
end

require "grpc"
require "proto/foo_pb"
require "proto/foo_services_pb"

class FooServer < Foo::FooService::Service
  def get_foo(_req, _call)
    Foo::GetFooResponse.new(name: "Hello from Bazel + Ruby gRPC server!")
  end
end

server = GRPC::RpcServer.new
server.add_http2_port("0.0.0.0:50051", :this_port_is_insecure)
server.handle(FooServer.new)
puts "gRPC server listening on 0.0.0.0:50051"
server.run_till_terminated
EOF
~~~

Declare a dependency on the `proto_library` target:

~~~sh
buildozer "add deps //proto:foo_proto" app:hello
~~~

Finally run it, verify the gRPC service responds, then shut it down:

~~~sh
cleanup() {
    kill $server_pid 2>/dev/null
    wait $server_pid 2>/dev/null || true
}
trap cleanup EXIT

bazel run app:hello &
server_pid=$!

# Wait for the gRPC server to be ready (timeout after 30 seconds)
for i in $(seq 1 6); do
    if response=$(buf curl --schema proto --protocol grpc --http2-prior-knowledge \
        -d '{"empty":{}}' \
        http://localhost:50051/foo.FooService/GetFoo 2>/dev/null); then
        echo "Server responded: $response"
        break
    fi
    if [ $i -eq 6 ]; then
        echo >&2 "Timed out waiting for server to start"
        exit 1
    fi
    sleep 5
done

# Verify the response
echo "$response" | grep -q "Hello from Bazel + Ruby gRPC server!" || {
    echo >&2 "Unexpected response: $response"
    exit 1
}
~~~
```
