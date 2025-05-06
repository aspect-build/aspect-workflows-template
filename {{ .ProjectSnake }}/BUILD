"""Targets in the repository root"""
{{- if or .Computed.javascript .Computed.python }}
{{ if .Computed.javascript }}
load("@aspect_rules_js//js:defs.bzl", "js_library")
load("@npm//:defs.bzl", "npm_link_all_packages")
{{- end }}
{{- if .Computed.python }}
load("@pip//:requirements.bzl", "all_whl_requirements")
load("@rules_python_gazelle_plugin//manifest:defs.bzl", "gazelle_python_manifest")
load("@rules_python_gazelle_plugin//modules_mapping:def.bzl", "modules_mapping")
{{- end }}
{{- end }}
{{- if .Scaffold.lint }}

# gazelle:build_file_name BUILD

{{ if .Computed.javascript }}
# TODO: remove once https://github.com/aspect-build/aspect-cli/issues/560 done
# gazelle:js_npm_package_target_name pkg
{{- end }}

alias(
    name = "format",
    actual = "//tools/format",
)
{{- end }}
{{- if .Computed.shell }}
exports_files(
    [".shellcheckrc"],
    visibility = ["//:__subpackages__"],
)
{{- end }}
{{- if .Computed.python }}

exports_files(
    ["pyproject.toml"],
    visibility = ["//:__subpackages__"],
)
{{- end }}
{{- if .Computed.javascript }}

npm_link_all_packages(name = "node_modules")
{{- if .Scaffold.lint }}

js_library(
    name = "eslintrc",
    srcs = ["eslint.config.mjs"],
    visibility = ["//:__subpackages__"],
    deps = [
        ":node_modules/@eslint/js",
        ":node_modules/typescript-eslint",
    ],
)

js_library(
    name = "prettierrc",
    srcs = ["prettier.config.cjs"],
    deps = [],
    visibility = ["//tools/format:__pkg__"],
)
{{- end }}
{{- end }}
{{- if .Computed.python }}

# Set `aspect configure` to produce aspect_rules_py targets rather than rules_python
# aspect:map_kind py_binary py_binary @aspect_rules_py//py:defs.bzl
# aspect:map_kind py_library py_library @aspect_rules_py//py:defs.bzl
# aspect:map_kind py_test py_test @aspect_rules_py//py:defs.bzl
#
# Don't walk into virtualenvs when looking for python sources.
# We don't intend to plant BUILD files there.
# aspect:exclude **/*.venv
#
# Fetches metadata for python packages we depend on.
modules_mapping(
    name = "modules_map",
    wheels = all_whl_requirements,
)

# Provide a mapping from an import to the installed package that provides it.
# Needed to generate BUILD files for .py files.
# This macro produces two targets:
# - //:gazelle_python_manifest.update can be used with `bazel run`
#   to recalculate the manifest
# - //:gazelle_python_manifest.test is a test target ensuring that
#   the manifest doesn't need to be updated
gazelle_python_manifest(
    name = "gazelle_python_manifest",
    modules_mapping = ":modules_map",
    pip_repository_name = "pip",
)

{{- end }}
