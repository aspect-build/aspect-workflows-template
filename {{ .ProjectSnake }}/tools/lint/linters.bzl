"Define linter aspects"

{{ if .Computed.cpp -}}
load("@aspect_rules_lint//lint:clang_tidy.bzl", "lint_clang_tidy_aspect")
{{ end -}}
{{ if .Computed.javascript -}}
load("@aspect_rules_lint//lint:eslint.bzl", "lint_eslint_aspect")
{{ end -}}
load("@aspect_rules_lint//lint:lint_test.bzl", "lint_test")
{{ if .Computed.java -}}
load("@aspect_rules_lint//lint:pmd.bzl", "lint_pmd_aspect")
{{ end -}}
{{ if .Computed.python -}}
load("@aspect_rules_lint//lint:ruff.bzl", "lint_ruff_aspect")
{{ end -}}
load("@aspect_rules_lint//lint:shellcheck.bzl", "lint_shellcheck_aspect")

{{ if .Computed.cpp -}}
clang_tidy = lint_clang_tidy_aspect(
    binary = "@@//tools/lint:clang_tidy",
    configs = ["@@//:.clang-tidy"],
    lint_target_headers = True,
    angle_includes_are_system = False,
    verbose = False,
)
{{ end -}}
{{ if .Computed.java -}}
pmd = lint_pmd_aspect(
    binary = "@@//tools/lint:pmd",
    rulesets = ["@@//:pmd.xml"],
)
{{ end -}}
{{ if .Computed.javascript -}}
eslint = lint_eslint_aspect(
    binary = "@@//tools/lint:eslint",
    # We trust that eslint will locate the correct configuration file for a given source file.
    # See https://eslint.org/docs/latest/use/configure/configuration-files#cascading-and-hierarchy
    configs = [
        "@@//:eslintrc",
        # if the repository has nested eslintrc files, they must be added here as well
    ],
)

eslint_test = lint_test(aspect = eslint)
{{ end -}}
{{ if .Computed.python -}}
ruff = lint_ruff_aspect(
    binary = "@multitool//tools/ruff",
    configs = [
        "@@//:pyproject.toml",
        # if the repository has nested ruff.toml files, they must be added here as well
    ],
)

ruff_test = lint_test(aspect = ruff)

{{ end -}}
{{ if .Computed.shell }}
shellcheck = lint_shellcheck_aspect(
    binary = "@multitool//tools/shellcheck",
    config = "@@//:.shellcheckrc",
)

shellcheck_test = lint_test(aspect = shellcheck)
{{ end -}}
