# frozen_string_literal: true

require 'test_helper'

require 'minitest/autorun'

class DeepSymbolizeKeysTest < Minitest::Test
  def test_deep_symbolize_keys
    cases = {
      { 'a' => 1 } => { a: 1 },
      { b: 2 } => { b: 2 },
      { 'c' => [3] } => { c: [3] },
      { 'x' => { 'y' => [{ 'z' => 26 }, 27] } } => { x: { y: [{ z: 26 }, 27] } }
    }

    cases.each do |input, expected|
      assert_equal(expected, input.deep_symbolize_keys)
    end
  end
end
