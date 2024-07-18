#!/bin/sh
# See https://blog.aspect.build/run-tools-installed-by-bazel
target="@multitool//tools/$(basename "$0")"
# NB: we don't use 'bazel run' because it may leave behind zombie processes under ibazel
bazel 2>/dev/null build "$target" && exec $(bazel info execution_root)/$(bazel 2>/dev/null cquery --output=files "$target") "$@"
