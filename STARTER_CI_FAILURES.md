# Starter-repo CI failures (post-modernization sync)

Triage of the `main`-branch CI failures across the 12 `aspect-starters/*` repos
after they were synced from the modernized template (run timestamps 2026-06-16
~21:12 UTC). `ASPECT_API_TOKEN` auth is **resolved** (org secret added); every
failure below is real and deterministic (reproduced across consecutive runs).

We'll land the release-pipeline change first, then fix the template to green up
these downstream repos.

## Failure categories

### 1. Publish pipeline doesn't normalize formatting → buildifier + gazelle fail (ALL 12)

**Symptom:** `buildifier` ("N files need formatting") and `gazelle` ("BUILD files
are out of date") fail in every preset. The stamped `BUILD.bazel` / `MODULE.bazel`
/ `*.bzl` files carry runs of stray blank lines (e.g. published
`aspect-starters/minimal` `MODULE.bazel` has 11+ consecutive blank lines at
lines 12-21) and minor non-canonical Starlark (`} | MULTITOOL_TOOLS ,`,
un-sorted kwargs, a 1-byte `.aspect/gazelle/BUILD.bazel`).

**Root cause:** the jinja2 renderer leaves blank lines where conditional blocks
were stripped. The **template repo's own CI normalizes this post-render**
(`buildifier -r .` + `aspect format`, then amends), but the
**`publish-starters.yaml` job does NOT** — it runs only `tools/repin`, so the
starters ship raw, un-formatted render output.

**Fix (publish side, primary):** add a post-render `buildifier -r .` + `aspect
format` normalization step to `publish-starters.yaml`, mirroring the template
CI's post-scaffold step, before committing/pushing each preset.

**Fix (render side, secondary, nice-to-have):** tighten jinja whitespace control
so the raw render is closer to buildifier-clean (reduces churn, helps local
`render-preset` users). Not strictly required if the publish job normalizes.

Affected: minimal, shell, go, js, py, java, kotlin, cpp, rust, ruby, scala,
kitchen-sink (file counts vary 5–13 per repo by preset).

### 2. `lint` task: "No lint aspect configured" (go, rust, scala)

**Symptom:**
```
ERROR: No lint aspect configured. Pass --aspect=<label>
  (e.g. --aspect=//tools/lint:linters.bzl%shellcheck) or add --aspects=… via a bazelrc --config.
→ ❌ Failed `lint` task (exit code 1)
```

**Root cause:** go/rust/scala have lint enabled but no wired rules_lint aspect
(go's nogo is a build-time vet, not an `aspect lint` aspect; rust clippy lives in
the unpublished `aspect_rules_lint_rust` module; scala has none). `aspect lint
//...` with an empty aspect set errors instead of no-op'ing.

**Status:** the template repo's *own* CI already skips lint for
minimal/go/scala/rust, and `template/.aspect/config.axl` only stamps the
`ctx.tasks["lint"].args.aspects` block when ≥1 linter exists — so a go/rust/scala
project should have **no lint task wired**. The starters fail because the
**stamped `.github/workflows/ci.yaml` runs `aspect lint` unconditionally** for
every preset, even those with no linter.

**Fix:** gate the generated `lint` job in `template/.github/workflows/ci.yaml` on
the preset actually having a linter (same condition as the config.axl aspects
block: shell/js/python/cpp/kotlin/java/ruby), OR make `aspect lint` a no-op when
no aspects are configured.

### 3. gazelle `kt_jvm_library` name collisions (kotlin, kitchen-sink)

**Symptom (kitchen-sink):**
```
failed to generate target "//hello/js" of kind "kt_jvm_library": a target of kind "ts_project" with the same name already exists.
failed to generate target "//hello/py" of kind "kt_jvm_library": a target of kind "py_library" with the same name already exists.
failed to generate target "//tools/gazelle" of kind "kt_jvm_library": a target of kind "aspect_gazelle" with the same name already exists.
ERROR: Gazelle (-mode=diff) exited 1 with no diff output (likely a configuration error).
```
(kotlin: the same collision on `//tools/gazelle`.)

**Root cause:** the Kotlin gazelle extension generates `kt_jvm_library` targets
named after the directory, colliding with existing hand-written / other-language
targets (`aspect_gazelle`, `ts_project`, `py_library`) in the same package.

**Fix:** scope the Kotlin gazelle extension (directives / `# gazelle:exclude` on
`tools/gazelle/BUILD.bazel` and the polyglot `hello/*` dirs), or disable Kotlin
rule generation outside the Kotlin sources.

### 4. delivery: `Config value 'release' is not defined` (kitchen-sink)

**Symptom:**
```
ERROR: Config value 'release' is not defined in any .rc file
```
`aspect delivery` runs `bazel build --config=release` (from
`config.axl`'s `release_bazel_flags`), but no `release` config exists in the
stamped bazelrc for this preset.

**Root cause:** `release_bazel_flags = ["--config=release"]` is stamped (gated on
the `stamp` flag) but the `common:release` bazelrc config it references is only
defined when the `stamp` preset.bazelrc section is present — a gating mismatch
between the delivery wiring and the `--config=release` definition.

**Fix:** ensure the `common:release` config is defined in the rendered bazelrc
whenever `release_bazel_flags`/delivery references it (align the `stamp`/`oci`
gating), or point delivery at flags that exist.

### 5. delivery: `image_push_write_tags` not runnable (go)

**Symptom:**
```
//hello/go:image_push_write_tags  FAIL  tagged 'deliverable' but not runnable
//hello/go:image_push             OK (FORCED)
```

**Root cause:** the delivery query `attr(tags, deliverable, //...)` matches both
the real `oci_push` (`:image_push`) and rules_oci's auto-generated
`:image_push_write_tags` companion, which inherits the tag but isn't runnable.

**Fix:** scope the `deliverable` tag in `bazel/oci/go_image.bzl` so only the
`oci_push` target carries it, or narrow the delivery query to runnable kinds.

## Summary matrix

| Preset | buildifier | gazelle | lint | delivery |
|--------|:---:|:---:|:---:|:---:|
| minimal | ❌ #1 | ❌ #1 | — | — |
| shell | ❌ #1 | ❌ #1 | ✅ | — |
| go | ❌ #1 | ❌ #1 | ❌ #2 | ❌ #5 |
| js | ❌ #1 | ❌ #1 | ✅ | — |
| py | ❌ #1 | ❌ #1 | ✅ | — |
| java | ❌ #1 | ❌ #1 | ✅ | — |
| kotlin | ❌ #1 | ❌ #3 | ✅ | — |
| cpp | ❌ #1 | ❌ #1 | ✅ | — |
| rust | ❌ #1 | ❌ #1 | ❌ #2 | — |
| ruby | ❌ #1 | ❌ #1 | ✅ | — |
| scala | ❌ #1 | ❌ #1 | ❌ #2 | — |
| kitchen-sink | ❌ #1 | ❌ #3 | ✅ | ❌ #4 |

(`build` and `test` pass in every preset.)

## Fix order (template-side)

1. **#1 publish normalization** — biggest win; greens buildifier+gazelle for the
   non-collision presets. Add buildifier/format to `publish-starters.yaml`.
2. **#2 lint job gating** — gate the stamped `lint` job on having a linter.
3. **#3 kotlin gazelle collisions** — directives to stop `kt_jvm_library`
   generation colliding in polyglot/tools dirs.
4. **#4 / #5 delivery** — fix the `release` config gating and the `deliverable`
   tag scope on the go oci_push.

## Secondary note: CI scope detection

All buildifier/gazelle jobs also warn:
```
Could not determine the changed-file set (git merge-base HEAD origin/main … none succeeded) … --scope=all
```
The stamped CI checkout lacks a base ref, so these tasks fall back to whole-repo
scope. Not the failure cause (the files genuinely need formatting), but worth a
`fetch-depth`/base-ref fix so future runs scope to changed files.
