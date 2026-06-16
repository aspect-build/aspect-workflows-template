#include <iostream>

#include "hello/cpp/hello.h"

int main() {
  std::cout << hello::Greeting("world") << '\n';
  return 0;
}
