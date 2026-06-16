package hello;

import static org.junit.Assert.assertEquals;

import org.junit.Test;

public class HelloTest {
  @Test
  public void testGreeting() {
    assertEquals("Hello, Bazel!", Hello.greeting("Bazel"));
  }
}
