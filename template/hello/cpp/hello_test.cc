#include "hello/cpp/hello.h"

#include <cassert>
#include <string>

int main() {
  const std::string greeting = hello::Greeting("Bazel");
  assert(greeting == "Hello, Bazel!");
  return 0;
}
