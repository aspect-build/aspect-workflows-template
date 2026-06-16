#include "hello/cpp/hello.h"

#include <string>
#include <string_view>

namespace hello {

std::string Greeting(std::string_view name) {
  return "Hello, " + std::string(name) + "!";
}

}  // namespace hello
