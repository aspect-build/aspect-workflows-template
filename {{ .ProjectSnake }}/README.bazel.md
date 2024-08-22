# Bazel workflows

This repository uses [Aspect Workflows](https://aspect.build) to provide an excellent Bazel developer experience.

{{- if .Scaffold.lint }}
## Formatting code

- Run `aspect run format` to re-format all files locally.
- Run `aspect run format path/to/file` to re-format a single file.
- Run `pre-commit install` to auto-format changed files on `git commit`.
- For CI verification, setup `format` task, see https://docs.aspect.build/workflows/features/lint#formatting
{{ end }}

## Linting code

We use [rules_lint](https://github.com/aspect-build/rules_lint) to run linting tools using Bazel's aspects feature.
Linters produce report files, which are cached like any other Bazel actions.
Printing the report files to the terminal can be done in a couple ways, as follows.

The [`lint` command](https://docs.aspect.build/cli/commands/aspect_lint) is provided by Aspect CLI but is *not* part of the Bazel CLI provided by Google.
It collects the correct report files, presents them with nice colored boundaries, gives you interactive suggestions to apply fixes, produces a matching exit code, and more.

- Run `aspect lint //...` to check for lint violations.

## Installing dev tools

For developers to be able to run a CLI tool without needing manual installation:

1. Add the tool to `tools/tools.lock.json`
2. `cd tools; ln -s _multitool_run_under_cwd.sh name_of_tool`
3. Instruct developers to run `./tools/name_of_tool` rather than install that tool on their machine.

See https://blog.aspect.build/run-tools-installed-by-bazel for details.

{{ if .Computed.javascript }}
## Working with npm packages

To install a `node_modules` tree locally for the editor or other tooling outside of Bazel:

```
aspect run -- @pnpm --dir $PWD install
```

Similarly, you can run other `pnpm` commands to install or remove packages.
This ensures you use the same pnpm version as other developers, and the lockfile format will stay constant.
{{- end }}

{{ if .Computed.python }}
## Working with Python packages

After adding a new `import` statement in Python code, run `aspect configure` to update the BUILD file.

If the package is not already a dependency of the project, you'll have to do some additional steps:

```shell
# Update dependencies table to include your new dependency
% vim pyproject.toml
# Update lock files to pin this dependency
% ./repin.sh
```

To create a runnable binary for a console script from a third-party package, run the following:

```shell
% cat<<'EOF' | ./tools/buildozer -f -
new_load @rules_python//python/entry_points:py_console_script_binary.bzl py_console_script_binary|new py_console_script_binary scriptname|tools:__pkg__
set pkg "@pip//package_name_snake_case"|tools:scriptname
EOF
```

Then edit the new entry in `tools/BUILD` to replace `package_name_snake_case` with the name of the package that exports a console script, and `scriptname` with the name of the script.

>[!NOTE]
>See https://rules-python.readthedocs.io/en/stable/api/python/entry_points/py_console_script_binary.html for more details.

{{- end }}

{{ if .Computed.go }}
## Working with Go modules

After adding a new `import` statement in Go code, run `aspect configure` to update the BUILD file.

If the package is not already a dependency of the project, you'll have to do some additional steps:

```shell
# Update go.mod and go.sum, using same Go SDK as Bazel
% aspect run @rules_go//go -- mod tidy -v
# Update MODULE.bazel to include the package in `use_repo`
% aspect mod tidy
# Repeat
% aspect configure
```

{{- end }}

{{ if .Scaffold.stamp }}
## Stamping release builds

Stamping produces non-deterministic outputs by including information such as a version number or commit hash.

Read more: https://blog.aspect.build/stamping-bazel-builds-with-selective-delivery

To declare a build output which can be stamped, use a rule that is stamp-aware such as
[expand_template](https://docs.aspect.build/rulesets/aspect_bazel_lib/docs/expand_template).

Available keys are listed in `/tools/workspace_status.sh` and may include:

- `STABLE_GIT_COMMIT`: the commit hash of the HEAD (current) commit
- `STABLE_MONOREPO_VERSION`: a semver-compatible version in the form `2020.44.123+abc1234`

To request stamped build outputs, add the flag `--config=release`.
{{ end }}
