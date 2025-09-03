# Go Bazel Starter

    alias ~~~=":<<'~~~sh'";:<<'~~~sh'

# Example user workflows within an `aspect init`-generated repository
# with the Go language enabled.
set -o errexit -o pipefail -o nounset

# Scaffold out a new command in the repo
scaffold new https://github.com/alexeagle/cowsay-go-scaffold Project=cowsay

# Create/update the go.mod file, including the nmyk.io/cowsay dependency pinning
go mod tidy
# Update the BUILD files
bazel run gazelle || true
bazel build cowsay/cmd/hello
# Run the application, starting a server
bazel run cowsay/cmd/hello &
# Wait for the server
while ! nc -z localhost 8080; do   
  sleep 0.5
done

output=$(curl localhost:8080)
# Verify the application output matches expectation
[[ "${output}" =~ "Hello, world" ]] || {
    echo >&2 "Wanted output containing 'Hello, world' but got '${output}'"
    exit 1
}

# Shutdown server
kill %1

# Build an OCI container for the target platform
# TODO: orion plugin
# bazel build //cmd/hello:image.load