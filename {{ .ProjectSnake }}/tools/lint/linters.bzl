"Define linter aspects"

{{ if .Computed.cpp -}}
load("@aspect_rules_lint//lint:clang_tidy.bzl", "lint_clang_tidy_aspect")
{{ end -}}
{{ if .Computed.javascript -}}
load("@aspect_rules_lint//lint:eslint.bzl", "lint_eslint_aspect")
{{ end -}}
load("@aspect_rules_lint//lint:lint_test.bzl", "lint_test")
{{ if .Computed.kotlin -}}
load("@aspect_rules_lint//lint:ktlint.bzl", "lint_ktlint_aspect")
{{ end -}}
{{ if .Computed.java -}}
load("@aspect_rules_lint//lint:pmd.bzl", "lint_pmd_aspect")
{{ end -}}
{{ if .Computed.python -}}
load("@aspect_rules_lint//lint:ruff.bzl", "lint_ruff_aspect")
load("@aspect_rules_lint//lint:ty.bzl", "lint_ty_aspect")
{{ end -}}
{{ if .Computed.shell }}
load("@aspect_rules_lint//lint:shellcheck.bzl", "lint_shellcheck_aspect")
{{ end -}}

{{ if .Computed.cpp -}}
clang_tidy = lint_clang_tidy_aspect(
    binary = Label(":clang_tidy"),
    configs = [Label("//:.clang-tidy")],
    lint_target_headers = True,
    angle_includes_are_system = False,
    verbose = False,
)
{{ end -}}
{{ if .Computed.kotlin -}}
ktlint = lint_ktlint_aspect(
    binary = Label("@com_github_pinterest_ktlint//file"),
    editorconfig = Label("//:.editorconfig"),
    baseline_file = Label("//:ktlint-baseline.xml"),
)
{{ end -}}
{{ if .Computed.java -}}
pmd = lint_pmd_aspect(
    binary = Label(":pmd"),
    rulesets = [Label("//:pmd.xml")],
)
{{ end -}}
{{ if .Computed.javascript -}}
eslint = lint_eslint_aspect(
    binary = Label(":eslint"),
    # We trust that eslint will locate the correct configuration file for a given source file.
    # See https://eslint.org/docs/latest/use/configure/configuration-files#cascading-and-hierarchy
    configs = [
        Label("//:eslintrc"),
        # if the repository has nested eslintrc files, they must be added here as well
    ],
)

eslint_test = lint_test(aspect = eslint)
{{ end -}}
{{ if .Computed.python -}}
ruff = lint_ruff_aspect(
    binary = "@multitool//tools/ruff",
    configs = [
        Label("//:pyproject.toml"),
        # if the repository has nested ruff.toml files, they must be added here as well
    ],
)

ruff_test = lint_test(aspect = ruff)

ty = lint_ty_aspect(
    binary = Label("@aspect_rules_lint//lint:ty_bin"),
    config = Label("@//:ty.toml"),
)

{{ end -}}
{{ if .Computed.shell }}
shellcheck = lint_shellcheck_aspect(
    binary = "@multitool//tools/shellcheck",
    config = Label("//:.shellcheckrc"),
)

shellcheck_test = lint_test(aspect = shellcheck)
{{ end -}}
