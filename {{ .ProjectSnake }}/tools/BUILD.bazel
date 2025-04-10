"""Developer tool binaries"""
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
