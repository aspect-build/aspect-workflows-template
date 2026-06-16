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

Presets: `minimal`, `shell`, `go`, `js`, `py`, `java`, `kotlin`, `cpp`, `rust`,
`ruby`, `scala`, `kitchen-sink`.

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
