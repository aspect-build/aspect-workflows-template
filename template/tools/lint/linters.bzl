"Define linter aspects"

{% if cpp %}
load("@aspect_rules_lint//lint:clang_tidy.bzl", "lint_clang_tidy_aspect")
{% endif %}
{% if javascript %}
load("@aspect_rules_lint//lint:eslint.bzl", "lint_eslint_aspect")
{% endif %}
load("@aspect_rules_lint//lint:lint_test.bzl", "lint_test")
{% if kotlin %}
load("@aspect_rules_lint//lint:ktlint.bzl", "lint_ktlint_aspect")
{% endif %}
{% if java %}
load("@aspect_rules_lint//lint:pmd.bzl", "lint_pmd_aspect")
{% endif %}
{% if python %}
load("@aspect_rules_lint//lint:ruff.bzl", "lint_ruff_aspect")
load("@aspect_rules_lint//lint:ty.bzl", "lint_ty_aspect")
{% endif %}
{% if shell %}
load("@aspect_rules_lint//lint:shellcheck.bzl", "lint_shellcheck_aspect")
{% endif %}
{% if ruby %}
load("@aspect_rules_lint//lint:rubocop.bzl", "lint_rubocop_aspect")
{% endif %}

{% if cpp %}
clang_tidy = lint_clang_tidy_aspect(
    binary = Label("//tools/lint:clang_tidy"),
    configs = [Label("//:.clang-tidy")],
    lint_target_headers = True,
    angle_includes_are_system = False,
    verbose = False,
)
{% endif %}
{% if kotlin %}
ktlint = lint_ktlint_aspect(
    binary = Label("@com_github_pinterest_ktlint//file"),
    editorconfig = Label("//:.editorconfig"),
    baseline_file = Label("//:ktlint-baseline.xml"),
)
{% endif %}
{% if java %}
pmd = lint_pmd_aspect(
    binary = Label(":pmd"),
    rulesets = [Label("//:pmd.xml")],
)
{% endif %}
{% if javascript %}
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
{% endif %}
{% if python %}
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
    config = Label("@//:pyproject.toml"),
)

{% endif %}
{% if shell %}
shellcheck = lint_shellcheck_aspect(
    binary = "@multitool//tools/shellcheck",
    config = Label("//:.shellcheckrc"),
)

shellcheck_test = lint_test(aspect = shellcheck)
{% endif %}
{% if ruby %}
rubocop = lint_rubocop_aspect(
    binary = Label("@bundle//bin:rubocop"),
    configs = [Label("//:.rubocop.yml")],
)
{% endif %}