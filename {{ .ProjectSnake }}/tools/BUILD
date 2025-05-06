"""
Build supporting tools.

The tools subpackage is used to define build rules and configurations for tools
used throughout the repository. Firstparty tools not required for build support
should live elsewhere.

Of special note is that we're using the `bazel_env.bzl` tool to re-export tools
used under Bazel as a `bin/` tree which can be added to the `$PATH`. The
included `.envrc` automates this for you.

"""

load("@bazel_env.bzl", "bazel_env")
{{ if .Computed.javascript }}
load("@npm//:defs.bzl", "npm_link_all_packages")
{{ end }}
{{ if and .Scaffold.codegen .Computed.python }}
load("@rules_python//python/entry_points:py_console_script_binary.bzl", "py_console_script_binary")
{{ end  }}
load("@multitool//:tools.bzl", MULTITOOL_TOOLS = "TOOLS")

package(default_visibility = ["//visibility:public"])

{{ if and .Scaffold.codegen .Computed.python }}
py_console_script_binary(
    name = "copier",
    pkg = "@pip//copier",
)
{{ end }}

{{ if .Computed.javascript }}
{{ if .Scaffold.codegen }}
load("@npm//tools:yo/package_json.bzl", yo_bin = "bin")
yo_bin.yo_binary(name = "yo")
{{ end }}

npm_link_all_packages(name = "node_modules")

{{ end }}

bazel_env(
    name = "bazel_env",
    toolchains = {
{{ if .Computed.java }}
        "jdk": "@rules_java//toolchains:current_host_java_runtime",
{{ end }}
{{ if .Computed.python }}
        "python": "@rules_python//python:current_py_toolchain",
{{ end }}
{{ if .Computed.javascript }}
        "nodejs": "@nodejs_toolchains//:resolved_toolchain",
{{ end }}
    },
    tools = {
        # Mapping from tool binary name ($PATH entry) to Bazel label

        ## Firstparty tools
        "format": "@//tools/format:format",
        "repin": "@//tools/repin:repin",

        ## Thirdparty tools
{{ if .Scaffold.lint }}
        "buildifier": "@buildifier_prebuilt//:buildifier",
{{ end }}
{{ if .Computed.rust }}
        "cargo": "@rules_rust//tools/upstream_wrapper:cargo",
{{ end }}
{{ if .Computed.go }}
        "go": "@rules_go//go",
{{ end }}
{{ if .Computed.java }}
        "jar": "$(JAVABASE)/bin/jar",
        "java": "$(JAVA)",
{{ end }}
{{ if .Computed.javascript }}
        "node": "$(NODE_PATH)",
        "pnpm": "@pnpm",
{{ if .Scaffold.codegen }}
        "yo": ":yo",
{{ end }}
{{ end }}
{{ if .Computed.python }}
        "python": "$(PYTHON3)",
{{ end }}
    } | {
        t: "@multitool//tools/" + t
        for t in MULTITOOL_TOOLS
    },
)
