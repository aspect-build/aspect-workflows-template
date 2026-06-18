# Aspect Workflows project template

The source of truth for the starter projects scaffolded by **`aspect init`** and
published as ready-to-use template repositories under
[github.com/aspect-starters](https://github.com/aspect-starters).

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

## Repository layout

This repo is the editable source of truth for the template. It is rendered by a
single shared renderer that `aspect init`, this repo's CI, and the
`aspect-starters` publishing job all use, so they can never drift.

| Path | Purpose |
| --- | --- |
| `template/` | The jinja2 template tree rendered into a new project. |
| `template-config.json` | Template config **as data**: presets → feature flags, per-file inclusion rules, the copy-verbatim (`no_render`) list, and the executable list. Read at runtime by the renderer — `aspect init` never `load()`s any template code. |
| `render.axl` | The generic, template-agnostic renderer. Embedded in `aspect init`; reads `template-config.json` for everything template-specific (`render(ctx, config, template_dir, out_dir, project_snake, flags)`). |
| `dev.axl` | `aspect render-preset` task — renders one preset locally (used by CI + publishing). |
| `user_stories/` | Executable walkthroughs exercised in CI. |

### Render a preset locally

```shell
aspect render-preset --preset py --out /tmp/my_project --name my_project
```

Conditionals in the template use jinja2 (`{% if python %}` ...) with feature
flags from the selected preset; the project name is substituted as
`{{ project_snake }}`.

## Testing

CI renders every preset, regenerates lockfiles, then runs `aspect build`,
`aspect test`, and (for lint-enabled presets) `aspect lint` / `aspect format`
against the generated workspace — gating template changes before they land on
`main`. See `.github/workflows/ci.yaml`.
