#ifndef HELLO_CPP_HELLO_H_
#define HELLO_CPP_HELLO_H_

#include <string>
#include <string_view>

namespace hello {

// Returns a friendly greeting addressed to name.
std::string Greeting(std::string_view name);

}  // namespace hello

#endif  // HELLO_CPP_HELLO_H_
