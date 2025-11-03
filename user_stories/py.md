# Python Bazel Starter

    # This is executable Markdown that's tested on CI.
    set -o errexit -o nounset -o xtrace
    alias ~~~=":<<'~~~sh'";:<<'~~~sh'

This repo includes:
- 🧱 Latest version of Bazel and dependencies
- 📦 Curated bazelrc flags via [bazelrc-preset.bzl]
- 🧰 Developer environment setup with [bazel_env.bzl]
- 🎨 `ruff`, using rules_lint
- ✅ Pre-commit hooks for automatic linting and formatting
- 📚 PyPI package manager integration

## Try it out

> Before following these instructions, setup the developer environment by running <code>direnv allow</code> and follow any prompts.
> This ensures that tools we call in the following steps will be on the PATH.

Create a simple application with an external package dependency:

~~~sh
mkdir app
>app/__main__.py cat <<EOF
import requests
print(requests.get("https://api.github.com").status_code)
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
[ "${output}" = "200" ] || {
    echo >&2 "Wanted output '200' but got '${output}'"
    exit 1
}
~~~

## Scaffold out a library

Let's demonstrate using the `copier` utility to generate a new library in the project.
We'll need to link its requirements file into the `requirements.all` collector and re-pin again.

~~~sh
copier copy gh:alexeagle/aspect-template-python-lib mylib
buildozer "add data //mylib:requirements" //requirements:requirements.all
echo "-r ../mylib/requirements.txt" >> requirements/all.in
./tools/repin
~~~

Next, update the application we created earlier to use that library:

~~~sh
>app/__main__.py cat <<EOF
import requests
from mylib import say
say.marvin(requests.get("https://api.github.com").status_code)
EOF
~~~

And since the dependency graph was affected by that edit, we re-generate the `BUILD` file:

~~~sh
bazel run gazelle
~~~

Now run the application again to check it still works:

~~~sh
output=$(bazel run //app:app_bin)
echo "${output}" | grep -q "| 200 |" || {
    echo >&2 "Wanted output containing '| 200 |' but got '${output}'"
    exit 1
}
~~~
