package main

import "testing"

func TestGreeting(t *testing.T) {
	if got := greeting("Bazel"); got != "Hello, Bazel!" {
		t.Errorf("greeting() = %q", got)
	}
}
