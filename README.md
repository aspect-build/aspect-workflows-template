# Aspect Bazel Starters template

Ready-to-build [Bazel](https://bazel.build) projects, wired up with the
[Aspect CLI](https://aspect.build/docs/cli) and best-practice tooling. Pick a
language, generate a project, and start shipping — no Bazel boilerplate, no
toolchain yak-shaving.

This repo is the **source of truth** for both paths below: the projects
[`aspect init`](https://aspect.build/docs/cli) scaffolds and the template
repositories published under
[github.com/aspect-starters](https://github.com/aspect-starters) are rendered
from the one template tree here, so they never drift.

## Create a new project

### With the Aspect CLI (recommended)

Install the Aspect CLI: <https://aspect.build/docs/cli/install>

```shell
aspect init
```

`aspect init` fetches the latest template, prompts for the languages and features
you want (or pass `--preset <name>`), and renders a ready-to-build Bazel
workspace — no extra tools required.

### From a starter repository

Each preset is also published as a GitHub *template repository* under
[github.com/aspect-starters](https://github.com/aspect-starters) — click **Use
this template** (or **Fork**), or:

```shell
git clone https://github.com/aspect-starters/<preset>
```

The **Status** column shows the latest CI run on each starter's `main` branch.

| Repo | Stack | Status |
| --- | --- | --- |
| [minimal](https://github.com/aspect-starters/minimal) | An empty, correctly-configured Bazel workspace | [![CI](https://github.com/aspect-starters/minimal/actions/workflows/ci.yaml/badge.svg?branch=main)](https://github.com/aspect-starters/minimal/actions/workflows/ci.yaml?query=branch%3Amain) |
| [go](https://github.com/aspect-starters/go) | Go | [![CI](https://github.com/aspect-starters/go/actions/workflows/ci.yaml/badge.svg?branch=main)](https://github.com/aspect-starters/go/actions/workflows/ci.yaml?query=branch%3Amain) |
| [py](https://github.com/aspect-starters/py) | Python | [![CI](https://github.com/aspect-starters/py/actions/workflows/ci.yaml/badge.svg?branch=main)](https://github.com/aspect-starters/py/actions/workflows/ci.yaml?query=branch%3Amain) |
| [js](https://github.com/aspect-starters/js) | JavaScript & TypeScript | [![CI](https://github.com/aspect-starters/js/actions/workflows/ci.yaml/badge.svg?branch=main)](https://github.com/aspect-starters/js/actions/workflows/ci.yaml?query=branch%3Amain) |
| [java](https://github.com/aspect-starters/java) | Java | [![CI](https://github.com/aspect-starters/java/actions/workflows/ci.yaml/badge.svg?branch=main)](https://github.com/aspect-starters/java/actions/workflows/ci.yaml?query=branch%3Amain) |
| [kotlin](https://github.com/aspect-starters/kotlin) | Kotlin | [![CI](https://github.com/aspect-starters/kotlin/actions/workflows/ci.yaml/badge.svg?branch=main)](https://github.com/aspect-starters/kotlin/actions/workflows/ci.yaml?query=branch%3Amain) |
| [scala](https://github.com/aspect-starters/scala) | Scala | [![CI](https://github.com/aspect-starters/scala/actions/workflows/ci.yaml/badge.svg?branch=main)](https://github.com/aspect-starters/scala/actions/workflows/ci.yaml?query=branch%3Amain) |
| [cpp](https://github.com/aspect-starters/cpp) | C & C++ | [![CI](https://github.com/aspect-starters/cpp/actions/workflows/ci.yaml/badge.svg?branch=main)](https://github.com/aspect-starters/cpp/actions/workflows/ci.yaml?query=branch%3Amain) |
| [rust](https://github.com/aspect-starters/rust) | Rust | [![CI](https://github.com/aspect-starters/rust/actions/workflows/ci.yaml/badge.svg?branch=main)](https://github.com/aspect-starters/rust/actions/workflows/ci.yaml?query=branch%3Amain) |
| [ruby](https://github.com/aspect-starters/ruby) | Ruby | [![CI](https://github.com/aspect-starters/ruby/actions/workflows/ci.yaml/badge.svg?branch=main)](https://github.com/aspect-starters/ruby/actions/workflows/ci.yaml?query=branch%3Amain) |
| [shell](https://github.com/aspect-starters/shell) | Bash / shell | [![CI](https://github.com/aspect-starters/shell/actions/workflows/ci.yaml/badge.svg?branch=main)](https://github.com/aspect-starters/shell/actions/workflows/ci.yaml?query=branch%3Amain) |
| [kitchen-sink](https://github.com/aspect-starters/kitchen-sink) | Everything — all languages + OCI, protobuf, release stamping, codegen | [![CI](https://github.com/aspect-starters/kitchen-sink/actions/workflows/ci.yaml/badge.svg?branch=main)](https://github.com/aspect-starters/kitchen-sink/actions/workflows/ci.yaml?query=branch%3Amain) |

Building a polyglot monorepo? Start from
[**kitchen-sink**](https://github.com/aspect-starters/kitchen-sink) — every
language and feature wired together — or run `aspect init --preset kitchen-sink`.

## What every starter gives you

- 🧱 **Latest Bazel** (bzlmod) with curated flags via [`bazelrc-preset.bzl`](https://github.com/bazel-contrib/bazelrc-preset.bzl)
- 🧰 **Hermetic dev environment** via [`bazel_env.bzl`](https://github.com/buildbuddy-io/bazel_env.bzl) + [`rules_multitool`](https://github.com/theoremlp/rules_multitool) — tools on your PATH, no manual installs
- 🎨 **Formatting & linting** built in with [`rules_lint`](https://github.com/aspect-build/rules_lint)
- 📦 **Native package-manager integration** for the language (pip/uv, pnpm, go.mod, Cargo, Maven, Bundler, …)
- ⚙️ **Working GitHub Actions CI** that runs `aspect build`/`test`/`lint`/`format` on ephemeral runners — green out of the box
- 🐳 **OCI containers** via [`rules_oci`](https://github.com/bazel-contrib/rules_oci) (where applicable)
- 📌 A **pinned Aspect CLI version** (`.aspect/version.axl`) so your whole team and CI use the same tooling

## Contributing

The rest of this README is for maintainers of the template itself. Found a bug
or want to improve a starter? The starter repos are **generated artifacts** —
file issues and PRs here, against this repo, not against the `aspect-starters`
repos.

### Repository layout

One shared renderer drives all three consumers (`aspect init`, this repo's CI,
and the `aspect-starters` publishing job):

| Path | Purpose |
| --- | --- |
| `template/` | The jinja2 template tree rendered into a new project. |
| `template-config.json` | Template config **as data**: presets → feature flags, per-file inclusion rules, the copy-verbatim (`no_render`) list, and the executable list. Read at runtime by the renderer — `aspect init` never `load()`s any template code. |
| `render.axl` | The generic, template-agnostic renderer. Embedded in `aspect init`; reads `template-config.json` for everything template-specific (`render(ctx, config, template_dir, out_dir, project_snake, flags)`). |
| `dev.axl` | `aspect render-preset` task — renders one preset locally (used by CI + publishing). |
| `user_stories/` | Executable walkthroughs exercised in CI. |

#### Render a preset locally

```shell
aspect render-preset --preset py --out /tmp/my_project --name my_project
```

Conditionals in the template use jinja2 (`{% if python %}` ...) with feature
flags from the selected preset; the project name is substituted as
`{{ project_snake }}`.

### Testing

CI renders every preset, regenerates lockfiles, then runs `aspect build`,
`aspect test`, and (for lint-enabled presets) `aspect lint` / `aspect format`
against the generated workspace — gating template changes before they land on
`main`. See `.github/workflows/ci.yaml`.
