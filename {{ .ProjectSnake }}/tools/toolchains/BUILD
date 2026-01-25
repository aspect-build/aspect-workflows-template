"Locally declared toolchains resolving to tools managed in this repo"
{{ if and .Scaffold.proto .Computed.ruby }}
load("@rules_ruby//ruby:proto.bzl", "rb_grpc_protoc_plugin_toolchain")

rb_grpc_protoc_plugin_toolchain(
    name = "grpc_protoc_plugin",
    grpc_plugin = "//tools:grpc_tools_ruby_protoc_plugin",
)
{{ end }}
