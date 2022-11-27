# frozen_string_literal: true

require 'test_helper'

require 'aruba/api'
require 'generator'
require 'minitest/autorun'

Aruba.configure do |config|
  config.working_directory = '.'
end

class GenerateTest < Minitest::Test
  include Aruba::Api

  def setup
    setup_aruba(false)
  end

  def test_displays_version
    run_command_and_stop 'ruby generate.rb --version'

    assert_equal('generate.rb version 0.1.0', last_command_started.output.chomp)
  end
end

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
