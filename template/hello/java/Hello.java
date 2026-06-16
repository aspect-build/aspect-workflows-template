package hello;

/** Prints a friendly greeting. */
public final class Hello {
  private Hello() {}

  public static String greeting(String name) {
    return "Hello, " + name + "!";
  }

  public static void main(String[] args) {
    System.out.println(greeting("world"));
  }
}
