"""BUILD definition for the formatter binary

This is in its own package because it has so many loading-time symbols,
we don't want to trigger eager fetches of these for builds that don't want to run format.
"""

load("@aspect_rules_lint//format:defs.bzl", "format_multirun")

# gazelle:exclude
package(default_visibility = ["//:__subpackages__"])

{{ if .Computed.javascript }}
load("@npm//:prettier/package_json.bzl", prettier = "bin")

prettier.prettier_binary(
    name = "prettier",
    # Allow the binary to be run outside bazel
    env = {"BAZEL_BINDIR": "."},
    # Include this js_library and its dependencies in the runfiles (runtime dependencies)
    data = ["//:prettierrc"],
    fixed_args = [
        # `require` statements in the config file will be resolved relative to its location
        # Therefore to make it hermetic, prettier must be pointed at the copy of the config file
        # in the runfiles folder rather than the one in the source folder.
        "--config=\"$$JS_BINARY__RUNFILES\"/$(rlocationpath //:prettierrc)",
        # default log level is "log" which spams on success
        # https://prettier.io/docs/en/cli.html#--log-level
        "--log-level=warn",
    ],
)
{{ end }}

{{ if .Computed.kotlin }}
java_binary(
    name = "ktfmt",
    main_class = "com.facebook.ktfmt.cli.Main",
    runtime_deps = ["@ktfmt//jar"],
)
{{ end }}

format_multirun(
    name = "format",
{{ if .Computed.cpp}}
    cc = "@llvm_toolchain_llvm//:bin/clang-format",
{{ end }}
{{ if .Computed.go }}
    go = "@aspect_rules_lint//format:gofumpt",
{{ end }}
{{ if .Computed.javascript }}
    javascript = ":prettier",
{{ end }}
{{ if .Computed.kotlin }}
    kotlin = ":ktfmt",
{{ end }}
{{ if .Computed.python }}
    python = "@aspect_rules_lint//format:ruff",
{{ end }}
{{ if .Computed.rust }}
    rust = "@rules_rust//tools/rustfmt:upstream_rustfmt",
{{ end }}
{{ if .Computed.shell }}
    shell = "@aspect_rules_lint//format:shfmt",
{{ end }}
    starlark = "@buildifier_prebuilt//:buildifier",
)
