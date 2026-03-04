# Python Bazel Starter

    # This is executable Markdown that's tested on CI.
    # How is that possible? See https://gist.github.com/bwoods/1c25cb7723a06a076c2152a2781d4d49
    set -o errexit -o nounset -o xtrace
    alias ~~~=":<<'~~~sh'";:<<'~~~sh'

This repo includes:
- 🧱 Latest version of Bazel and dependencies
- 📦 Curated bazelrc flags via [bazelrc-preset.bzl]
- 🧰 Developer environment setup with [bazel_env.bzl]
- 🎨 Linting with `ruff`
- ✅ Pre-commit hooks for automatic linting and formatting
- 📚 PyPI package manager integration
- 🎨 Type-checking with [ty](https://docs.astral.sh/ty/)

> [!NOTE]
> You can customize languages and features with the interactive wizard in the <code>aspect init</code> command.
> <code>init</code> is an alternative to this starter repo, which was generated using the 'py' preset.
> See https://docs.aspect.build/cli/overview

## Setup dev environment

First, we recommend you setup a Bazel-based developer environment with direnv.

1. install https://direnv.net/docs/installation.html
1. run <code>direnv allow</code> and follow the prompts to <code>bazel run //tools:bazel_env</code>

This isn't strictly required, but the commands which follow assume that needed tools are on the PATH,
so skipping `direnv` means you're responsible for installing them yourself.

## Try it out

Create a simple application with an external package dependency:

~~~sh
mkdir app
>app/__main__.py cat <<EOF
import requests
print(requests.get("https://www.google.com/generate_204").status_code)
EOF
~~~

Let's create a simple failing test:

~~~sh
>app/app_test.py cat <<EOF
def test_bad():
  assert 1 == 2
EOF
~~~

Next, we need to declare the `requests` dependency in the project definition.
There's not a good machine-editing utility for TOML that I could find,
so we'll just use `sed` here to illustrate:

~~~sh
sed -i 's/dependencies = \[/dependencies = ["requests",/' pyproject.toml
~~~

Now we need to re-pin the dependencies to the lockfile:

~~~sh
./tools/repin
~~~

Generate `BUILD` files:

~~~sh
bazel run gazelle
~~~

That's it, now the application should execute:

~~~sh
output=$(bazel run //app:app_bin)
~~~

Let's verify the application output matches expectation:

~~~sh
[ "${output}" = "204" ] || {
    echo >&2 "Wanted output '204' but got '${output}'"
    exit 1
}
~~~

And type-check it by running linters:

~~~sh
aspect lint
~~~

## Scaffold out a library

Let's demonstrate using the `copier` utility to generate a new library in the project.
We'll need to link its requirements file into the `requirements.all` collector and re-pin again.

~~~sh
copier copy gh:alexeagle/aspect-template-python-lib mylib --vcs-ref HEAD
buildozer "add data //mylib:requirements" //requirements:requirements.all
echo "-r ../mylib/requirements.txt" >> requirements/all.in
./tools/repin
~~~

Next, update the application we created earlier to use that library:

~~~sh
>app/__main__.py cat <<EOF
import requests
from mylib import say
say.marvin(str(requests.get("https://www.google.com/generate_204").status_code))
EOF
~~~

And since the dependency graph was affected by that edit, we re-generate the `BUILD` file:

~~~sh
bazel run gazelle
~~~

Now run the application again to check it still works:

~~~sh
output=$(bazel run //app:app_bin)
echo "${output}" | grep -q "| 204 |" || {
    echo >&2 "Wanted output containing '| 204 |' but got '${output}'"
    exit 1
}
~~~

We can use the `uv` lock file.

~~~sh
uv lock
~~~

And run ruff and ty for linting:

~~~sh
aspect lint
~~~
