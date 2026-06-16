package hello

import org.junit.Assert.assertEquals
import org.junit.Test

class HelloTest {
  @Test
  fun testGreeting() {
    assertEquals("Hello, Bazel!", greeting("Bazel"))
  }
}
