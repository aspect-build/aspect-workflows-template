package hello

import org.scalatest.funsuite.AnyFunSuite

class HelloTest extends AnyFunSuite {
  test("greeting") {
    assert(Hello.greeting("Bazel") == "Hello, Bazel!")
  }
}
