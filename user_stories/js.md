# JavaScript / TypeScript Bazel Starter

    alias ~~~=":<<'~~~sh'";:<<'~~~sh'

# Example user workflows within an `aspect init`-generated repository
# with the JavaScript / TypeScript language enabled.
set -o errexit -o pipefail -o nounset

# Demonstrate that the pnpm tool can be run
pnpm list

# Scaffold out a library and add its dependencies
pnpm add -w generator-bazel-fastify-route
yo bazel-fastify-route
