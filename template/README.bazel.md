# Bazel workflows

This repository uses [Aspect Workflows](https://aspect.build) to provide an excellent Bazel developer experience.
It was generated from the Aspect Workflows template — create your own with `aspect init`
(see https://aspect.build/docs/cli) or from a starter at https://github.com/aspect-starters.

## Getting started

1. Install the Aspect CLI — see https://aspect.build/docs/cli/install. The `aspect`
   command pins this workspace's CLI version (via `.aspect/version.axl`) and wraps
   Bazel, so use it in place of `bazel`.
2. Set up a Bazel-based developer environment with [direnv](https://direnv.net): run `direnv allow`
   and follow the prompts to `bazel run //tools:bazel_env` (puts the project's tools — including
   `aspect` itself — on your PATH, so an `aspect` installed in step 1 isn't required once direnv is active).
3. Build and test everything:

   ```shell
   aspect build //...
   aspect test //...
   ```
{% if go or python or javascript or java or kotlin or scala or cpp or rust or ruby or shell %}
   A small `hello/` sample is included for each selected language as a starting point.
{% endif %}

{% if lint %}

## Formatting code

`format` is put on your PATH by `bazel_env` (via `.envrc`).

- Run `format` to re-format all files locally.
- Run `format path/to/file` to re-format a single file.
- On CI, run the `format` task to verify formatting; see https://aspect.build/docs/cli/tasks-ci

## Linting code

This project uses [rules_lint](https://github.com/aspect-build/rules_lint) to run linters as Bazel
aspects. The linters are configured in `.aspect/config.axl` and run via the Aspect CLI's `lint`
command (not the upstream Bazel CLI), which collects the cached report files, applies fixes
interactively, and sets a matching exit code.

- Run `aspect lint //...` to check for lint violations.

{% endif %}

## Installing dev tools

For developers to be able to run additional CLI tools without needing manual installation:

1. Add the tool to `tools/tools.lock.json`
2. Run <code>bazel run //tools:bazel_env</code> (following any instructions it prints)
3. When working within the workspace, tools will be available on the PATH

See https://aspect.build/blog/run-tools-installed-by-bazel for details.

{% if javascript %}

## Working with npm packages

To install a `node_modules` tree locally for the editor or other tooling outside of Bazel:

```shell
% pnpm install
```

Similarly, you can run other `pnpm` commands to add or remove packages. Use `bazel info workspace` to avoid having a bunch of `../` segments when running tools from a subdirectory:

```shell
path/to/package% $(bazel info workspace)/tools/pnpm add http-server
```

This ensures you use the same pnpm version as other developers, and the lockfile format stays constant.
{% endif %}

{% if python %}

## Working with Python packages

Python targets (`py_binary`, `py_library`, `py_test`) use [aspect_rules_py](https://github.com/aspect-build/rules_py)
and are maintained by hand — see `hello/py/BUILD.bazel` for the pattern (`py_test` routes
through `//tools/pytest:defs.bzl`).

Third-party dependencies are managed with [uv](https://docs.astral.sh/uv/): declare them in
`pyproject.toml` and lock them into `uv.lock`, exposed as the `@pypi` hub.

```shell
# Add the dependency to pyproject.toml's [project] or [dependency-groups]
% vim pyproject.toml
# Regenerate uv.lock (and other lockfiles)
% ./tools/repin
```

Then depend on it as `@pypi//<package>` (e.g. `@pypi//requests`).

To create a runnable binary for a console script from a third-party package, add a
`py_console_script_binary` to `tools/BUILD.bazel`:

```starlark
load("@aspect_rules_py//uv:defs.bzl", "py_console_script_binary")

py_console_script_binary(
    name = "scriptname",
    pkg = "@pypi//package_name",
)
```

{% endif %}

{% if go %}

## Working with Go modules

After adding a new `import` statement in Go code, run `aspect gazelle` to update the BUILD file.

If the package is not already a dependency of the project, you have to do some additional steps:

```shell
# Update go.mod and go.sum, using same Go SDK as Bazel (it comes from direnv)
% go mod tidy -v
# Update MODULE.bazel to include the package in `use_repo`
% bazel mod tidy
# Repeat
% aspect gazelle
```

{% endif %}

{% if stamp %}

## Stamping release builds

Stamping bakes volatile values (a version, a commit hash) into build outputs. It's kept off normal
builds — which stay cacheable — and enabled only for releases via `--config=release`.

Read more: https://aspect.build/blog/stamping-bazel-builds-with-selective-delivery

Consume the values from a stamp-aware rule such as
[expand_template](https://registry.bazel.build/docs/bazel_lib/3.0.0#lib-expand_template-bzl).
`bazel/workspace_status.sh` defines the available keys, including:

- `STABLE_GIT_COMMIT` / `STABLE_GIT_SHORT_COMMIT`: the HEAD commit hash (full / short).
- `STABLE_MONOREPO_VERSION`: a semver version like `2025.44.123+abc1234`.
- `STABLE_MONOREPO_SHORT_VERSION`: the same without the `+build` metadata (`2025.44.123`).
- `STABLE_MONOREPO_IMAGE_TAG_VERSION`: registry-tag-safe (`+` → `-`).

A weekly GitHub Action (`.github/workflows/weekly_tag.yaml`) tags `<year>.<week>` so the version
increments automatically.

Build with stamping via `aspect build --config=release //...`.
{% endif %}
{% if oci %}

## Delivering container images

Targets tagged `deliverable` (e.g. the `:image_push` from the `hello/` sample's `go_image`) are
built and pushed by `aspect delivery`. The deliverable query and release flags are configured in
`.aspect/config.axl`; point each `oci_push`'s `repository` at your registry (the sample uses the
anonymous, ephemeral `ttl.sh`).

- Run `aspect delivery` to build + push deliverables.
{% endif %}

{% if rust %}

## Working with Cargo

You can run `cargo` outside of Bazel, using the tool installed on the PATH.

```console
% cargo add reqwest
    Updating crates.io index
      Adding reqwest v0.12.7 to dependencies.
             Features:
             + __tls
             + charset
             + default-tls
             + h2
             + http2
             + macos-system-configuration
             25 deactivated features
    Updating crates.io index
```

{% endif %}
