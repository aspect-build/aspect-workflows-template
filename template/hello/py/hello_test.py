"""Tests for the greeting helper."""

from hello.py.greet import greeting


def test_greeting() -> None:
    assert greeting("Bazel") == "Hello, Bazel!"
