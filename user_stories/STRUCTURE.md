# User Stories Common Structure

This document outlines the common structure used across all language-specific user story files in this repository.

## Features List

A bulleted list of features included in the repo:
- 🧱 Latest version of Bazel and dependencies
- 📦 Curated bazelrc flags via [bazelrc-preset.bzl]
- 🧰 Developer environment setup with [bazel_env.bzl]
- 🎨 Language-specific formatter/linter (varies by language)
- ✅ Pre-commit hooks for automatic linting and formatting
- 📚 Package manager integration (if applicable)

## Required Sections

All language user stories MUST include these sections:

### 1. "Try it out" Section
**Purpose**: Basic hello world application demonstrating the language works

**Structure**:
- Setup note about direnv
- Create application code (simple "Hello World" style)
- Package manager integration with an example package
- BUILD file generation
- Run and verify output

**Languages**: All (java, py, js, go, rust, ruby, kotlin, cpp, shell)

### 2. Formatting Section
**Purpose**: Demonstrate that code formatting works

**Implementation**: 
- Should be mentioned in features list (🎨 emoji)
- May be demonstrated via `format` command or pre-commit hooks
- Should show that formatting tools are available

**Status by Language**:
- ✅ Java: `google-java-format` (in features)
- ✅ Python: `ruff` (in features, demonstrated in linting)
- ✅ JavaScript: `prettier` (in features)
- ✅ Kotlin: `ktfmt` (in features)
- ✅ C/C++: `clang-format` (in features)
- ✅ Shell: `shfmt` (in features)
- ✅ Ruby: Mentioned in features but not demonstrated
- ❓ Rust: `rustfmt` (in features) - not demonstrated
- ❓ Go: Not explicitly mentioned

### 3. Linting Section
**Purpose**: Demonstrate that linting works with `aspect lint`

**Structure**:
- Run `aspect lint` command
- May include example output
- May show specific linting tool configuration

**Status by Language**:
- ✅ Java: `### Linting` section with PMD example output
- ✅ Python: Linting shown in "Try it out" and "Scaffold out a library"
- ✅ JavaScript: `## Linting` section
- ✅ Kotlin: Linting shown in "Try it out" section
- ✅ C/C++: `## Linting` section (with FIXME note)
- ✅ Shell: Linting shown in "Try it out" section
- ❌ Ruby: Missing explicit linting section
- ❌ Rust: Missing explicit linting section
- ❌ Go: Missing explicit linting section

## Optional Sections

### Protobuf and gRPC
**Purpose**: Demonstrate protobuf/gRPC integration

**Structure**:
- Create `.proto` file
- Generate BUILD rules (via Gazelle or manually)
- Create proto library target
- Show usage

**Status by Language**:
- ✅ Java: `## Using protobuf and gRPC` section
- ❌ Python: Missing
- ❌ JavaScript: Missing
- ❌ Go: Missing (though Go commonly uses protobuf)
- ❌ Kotlin: Missing
- ❌ Rust: Missing (though Rust commonly uses protobuf)
- ❌ Ruby: Missing
- ❌ C/C++: Missing
- ❌ Shell: N/A

### Code Generation
**Purpose**: Demonstrate code generation/scaffolding tools

**Status by Language**:
- ✅ Python: `## Scaffold out a library` section (uses copier)
- ✅ JavaScript: `## Code generation` section (uses Yeoman)
- ❌ Java: Missing
- ❌ Go: Missing (though scaffold is mentioned in "Try it out")
- ❌ Other languages: Missing

### Type Checking
**Purpose**: Demonstrate static type checking

**Status by Language**:
- ✅ Python: `ty` mentioned in features and demonstrated
- ✅ JavaScript/TypeScript: TypeScript support implied
- ❌ Other languages: Missing or N/A

### Additional Dependencies
**Purpose**: Show how to add and use external dependencies

**Status by Language**:
- ✅ Python: Third-party dependency (`requests`) in "Try it out"
- ✅ JavaScript: Third-party dependency (`chalk`) in "Node.js program"
- ✅ Ruby: Third-party dependency (`faker`) in "Try it out"
- ✅ C/C++: `## Add a dependency` section (libmagic)
- ✅ Go: Dependency management shown in "Try it out"
- ❌ Java: Missing explicit third-party dependency example
- ❌ Kotlin: Missing explicit third-party dependency example
- ❌ Rust: Missing explicit third-party dependency example
- ❌ Shell: N/A

### Developer Tools
**Purpose**: Show language-specific developer tools available

**Status by Language**:
- ✅ JavaScript: `## Developer tools` section (shows pnpm)
- ❌ Other languages: Missing or integrated into "Try it out"

## Section Coverage Matrix

| Language | Formatting | Linting | Protobuf/gRPC | Code Gen | Type Check | Third-party Deps | Dev Tools |
|----------|-----------|---------|---------------|----------|------------|------------------|----------|
| Java     | ✅         | ✅       | ✅            | ❌        | N/A        | ❌                | ❌        |
| Python   | ✅         | ✅       | ❌            | ✅        | ✅         | ✅                | ❌        |
| JavaScript| ✅        | ✅       | ❌            | ✅        | ✅         | ✅                | ✅        |
| Go       | ❓         | ❌       | ❌            | ❌        | N/A        | ✅                | ❌        |
| Rust     | ✅         | ❌       | ❌            | ❌        | N/A        | ❌                | ❌        |
| Ruby     | ✅         | ❌       | ❌            | ❌        | N/A        | ✅                | ❌        |
| Kotlin   | ✅         | ✅       | ❌            | ❌        | N/A        | ❌                | ❌        |
| C/C++    | ✅         | ✅       | ❌            | ❌        | N/A        | ✅                | ❌        |
| Shell    | ✅         | ✅       | N/A           | N/A       | N/A        | N/A               | ❌        |

## Common Patterns

### Output Verification
Most stories use one of these patterns:
- Exact match: `[ "${output}" = "expected" ]`
- Regex match: `echo "${output}" | grep -qE "pattern"`
- Contains check: `echo "${output}" | grep -q "text"`

### BUILD File Creation
- Gazelle generation (preferred when available)
- Manual `buildozer` commands
- Direct BUILD file content with heredoc

### Dependency Management
- Add to package manager config
- Update lockfiles
- Reference in BUILD files

## Recommendations

Based on the coverage matrix, languages missing key sections:

1. **Linting sections needed**: Ruby, Rust, Go
2. **Protobuf/gRPC sections needed**: Python, Go, Rust, Kotlin (common use cases)
3. **Third-party dependency examples needed**: Java, Kotlin, Rust
4. **Formatting demonstrations needed**: Rust, Go (if applicable)
