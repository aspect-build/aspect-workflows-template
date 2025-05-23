"""Definition of linter tools

This is in its own package because it has so many loading-time symbols,
we don't want to trigger eager fetches of these for builds which aren't running linters.
"""

package(default_visibility = ["//:__subpackages__"])

{{ if .Computed.javascript }}
load("@npm//:eslint/package_json.bzl", eslint_bin = "bin")

eslint_bin.eslint_binary(name = "eslint")
{{ end }}

{{ if .Computed.java }}
load("@rules_java//java:defs.bzl", "java_binary")

java_binary(
    name = "pmd",
    main_class = "net.sourceforge.pmd.PMD",
    runtime_deps = ["@net_sourceforge_pmd"],
)
{{ end }}

{{ if .Computed.cpp}}
load("@bazel_skylib//rules:native_binary.bzl", "native_binary")

native_binary(
    name = "clang_tidy",
    src = select(
        {
            "@bazel_tools//src/conditions:linux_x86_64": "@llvm_toolchain_llvm//:bin/clang-tidy",
            "@bazel_tools//src/conditions:linux_aarch64": "@llvm_toolchain_llvm//:bin/clang-tidy",
            "@bazel_tools//src/conditions:darwin_x86_64": "@llvm_toolchain_llvm//:bin/clang-tidy",
            "@bazel_tools//src/conditions:darwin_arm64": "@llvm_toolchain_llvm//:bin/clang-tidy",
            # llvm_toolchain doesn't support windows: https://github.com/bazel-contrib/toolchains_llvm/issues/4
            # as a workaround, you can download exes from
            # https://github.com/llvm/llvm-project/releases/tag/llvmorg-18.1.6 and make available locally.
            "@bazel_tools//src/conditions:windows_x64": "clang-tidy.exe",
        },
    ),
    out = "clang_tidy",
)
{{ end }}

{{ if .Computed.go }}
load("@rules_go//go:def.bzl", "nogo", "TOOLS_NOGO")

nogo(
    name = "nogo",
    deps = TOOLS_NOGO,
    visibility = ["//visibility:public"],
)
{{ end }}
