# frozen_string_literal: true

require 'minitest/autorun'
require_relative 'hello'

# Tests for the greeting helper.
class HelloTest < Minitest::Test
  def test_greeting
    assert_equal 'Hello, Bazel!', greeting('Bazel')
  end
end
