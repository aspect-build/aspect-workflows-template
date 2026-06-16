package hello

object Hello {
  def greeting(name: String): String = s"Hello, $name!"

  def main(args: Array[String]): Unit =
    println(greeting("world"))
}
