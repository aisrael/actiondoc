# frozen_string_literal: true

require 'aruba/api'
require 'minitest/autorun'

Aruba.configure do |config|
  config.working_directory = '.'
end

class GenerateTest < Minitest::Test
  include Aruba::Api

  def setup
    setup_aruba
  end

  def test_displays_version
      puts "in test_displays_version: #{Dir.pwd}"
      run_command_and_stop 'pwd'

      assert_equal('generate.rb version 0.1.0', last_command_started.output.chomp)
  end
end
