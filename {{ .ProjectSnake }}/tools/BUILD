"""Developer tool binaries"""
load("@bazel_env.bzl", "bazel_env")
load("@multitool//:tools.bzl", MULTITOOL_TOOLS = "TOOLS")

package(default_visibility = ["//visibility:public"])

[
    alias(name = tool, actual = "@multitool//tools/" + tool)
    # This list matches tools.lock.json
    for tool in [
        "buf",
        "buildozer",
        "docker-compose",
        "ibazel",
        "multitool",
        "terraform",
        "yq",
    ]
]

{{ if .Scaffold.lint }}
alias(name = "buildifier", actual = "@buildifier_prebuilt//:buildifier")
{{ end }}

{{ if .Computed.rust }}
# See https://github.com/bazelbuild/rules_rust/blob/main/docs/src/upstream_tooling.md
alias(name = "cargo", actual = "@rules_rust//tools/upstream_wrapper:cargo")
{{ end }}

{{ if .Computed.go }}
# https://github.com/bazelbuild/rules_go/blob/master/docs/go/core/bzlmod.md#using-a-go-sdk
alias(name = "go", actual = "@rules_go//go")
{{ end }}

{{ if and .Scaffold.codegen .Computed.python }}
load("@rules_python//python/entry_points:py_console_script_binary.bzl", "py_console_script_binary")

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

# https://github.com/aspect-build/rules_js/blob/main/docs/faq.md#can-i-use-bazel-managed-pnpm
alias(name = "pnpm", actual = "@pnpm")
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
{{ if .Computed.rust }}
        "rust": "@rules_rust//rust/toolchain:current_rust_toolchain",
{{ end }}
    },
    tools = {
        # Mapping from tool binary name ($PATH entry) to Bazel label
{{ if .Scaffold.lint }}
        "buildifier": "@buildifier_prebuilt//:buildifier",
{{ end }}
{{ if .Computed.rust }}
        "cargo": "$(CARGO)",
{{ end }}
{{ if and .Scaffold.codegen .Computed.python }}
        "copier": ":copier",
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
    } | MULTITOOL_TOOLS,
)
