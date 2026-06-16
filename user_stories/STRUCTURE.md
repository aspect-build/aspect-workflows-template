# User stories: shared structure

Each `user_stories/<preset>.md` is an **executable-Markdown** walkthrough for one
preset. CI runs it as a shell script (`sh user_stories/<preset>.md`) against a
freshly-rendered project, so every command in a fenced block is also a test — it
must actually run and pass. See `.github/workflows/ci.yaml` (the "User story"
step) and https://gist.github.com/bwoods/1c25cb7723a06a076c2152a2781d4d49 for how
the Markdown-as-shell trick works.

There is one story per preset: `minimal`, `kitchen-sink`, and one per language
(`go`, `py`, `js`, `java`, `kotlin`, `scala`, `rust`, `ruby`, `cpp`, `shell`).

## File anatomy

Every story opens with the same executable-Markdown preamble, then follows a
small fixed shape. Keep new stories consistent with it.

1. **Title** — `# <Language> Bazel Starter` (or a fitting variant).
2. **Preamble** (verbatim, indented as a code block so it's the first thing `sh`
   runs):
   ```
       # This is executable Markdown that's tested on CI.
       # How is that possible? See https://gist.github.com/bwoods/1c25cb7723a06a076c2152a2781d4d49
       set -o errexit -o nounset -o xtrace
       alias ~~~=":<<'~~~sh'";:<<'~~~sh'
   ```
   The `~~~` alias makes ```` ~~~sh ```` fenced blocks execute while prose
   between them is skipped.
3. **Feature bullets** — `This repo includes:` followed by, in order:
   - 🧱 Latest version of Bazel and dependencies
   - 📦 Curated bazelrc flags via [bazelrc-preset.bzl]
   - 🧰 Developer environment setup with [bazel_env.bzl]
   - 🎨 `<formatter>` and `<linter>`, using rules_lint — **only** for presets
     where lint is wired (go/scala/minimal omit this; see the lint coverage in
     `.github/workflows/ci.yaml`).
   - 📚 `<package manager>` integration — only for presets with one (Maven,
     PyPI, pnpm, go.mod, Cargo, …).
4. **`> [!NOTE]`** — names the preset and points at `aspect init --preset <p>`,
   the "Use this template" button, and the CLI docs. Same wording in every
   story; only the preset name changes.
5. **Body sections** (the `## ` headings), described below.

## Body sections

Language presets use three `## ` sections, in this order:

| Section | Purpose |
|---|---|
| `## Setup dev environment` | direnv + `bazel run //tools:bazel_env`. Identical prose across stories. |
| `## Build and test the sample` | Build/test/run the shipped `hello/<lang>` package and assert on its output. |
| `## Add your own code` | Create a new package (e.g. `cmd/greet`), wire its `BUILD` (Gazelle where available, hand-written otherwise), build + run it, assert output. |

The two non-language presets differ:

- **`minimal`** — no languages, so no `hello/` sample and no `## ` sections; it
  just asserts `bazel build //...` succeeds on the empty workspace.
- **`kitchen-sink`** — enables every language. Uses `## Setup dev environment`,
  `## Build and test the sample` (`aspect build //...` + `aspect test ...`), and
  `## Run a couple of the samples`, then defers to the per-language stories for
  "add your own code".

## Conventions

- **Output assertions** — capture into `output=$(...)` and check it, failing
  loudly. Prefer a `grep -q` contains-check with a descriptive `echo >&2` +
  `exit 1` on mismatch:
  ```sh
  output=$(bazel run //hello/<lang>:hello)
  echo "${output}" | grep -q "Hello, world!" || {
      echo >&2 "Wanted output containing 'Hello, world!' but got '${output}'"
      exit 1
  }
  ```
- **`aspect` vs `bazel`** — use `aspect build`/`aspect test` for the task-driven
  commands; `bazel run` is fine for running a binary and capturing its output.
- **`--task-key` on `aspect test`** — pass `--task-key test-<preset>-story` so the
  story's test run gets a distinct task identity from the CI `test` task it shares
  a workspace with (otherwise their state tracking collides). One key per story.
- **BUILD generation** — run `aspect gazelle` for languages that support it; for
  the others (Java, Kotlin, …) hand-write the `BUILD` with a heredoc and say so.
- **New files** — `mkdir -p` then `cat <<'EOF'` heredocs (quote the delimiter so
  the shell doesn't expand the file contents).

## Editing checklist

- The story renders cleanly for its preset and the whole thing runs under `sh`
  (CI's harness), not just bash.
- Feature bullets match what the preset actually ships — don't list tooling a
  preset doesn't enable.
- Output assertions are real (they fail when the command misbehaves), not
  decorative.
