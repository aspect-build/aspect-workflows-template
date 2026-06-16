# frozen_string_literal: true

# Prints a friendly greeting.
def greeting(name)
  "Hello, #{name}!"
end

puts greeting('world') if __FILE__ == $PROGRAM_NAME
