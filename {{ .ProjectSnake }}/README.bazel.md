# Bazel workflows

This repository uses [Aspect Workflows](https://aspect.build) to provide an excellent Bazel developer experience.

## Formatting code

- Run `aspect run format` to re-format all files locally.
- Run `aspect run format path/to/file` to re-format a single file.
- Run `pre-commit install` to auto-format changed files on `git commit`.
- For CI verification, setup `format` task, see https://docs.aspect.build/workflows/features/lint#formatting

## Installing dev tools

For developers to be able to run a CLI tool without needing manual installation:

1. Add the tool to `tools/tools.lock.json`
2. `cd tools; ln -s _multitool_run_under_cwd.sh name_of_tool`
3. Instruct developers to run `./tools/name_of_tool` rather than install that tool on their machine.

See https://blog.aspect.build/run-tools-installed-by-bazel for details.

{{ if eq .Computed.javascript "true" }}
## Working with npm packages

To install a `node_modules` tree locally for the editor or other tooling outside of Bazel:

```
bazel run -- @pnpm --dir $PWD install
```

Similarly, you can run other `pnpm` commands to install or remove packages.
This ensures you use the same pnpm version as other developers, and the lockfile format will stay constant.
{{- end }}
