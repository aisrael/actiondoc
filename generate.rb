#!/usr/bin/env ruby
# frozen_string_literal: true

########################################
# generate.rb
#
# A Ruby script to generate documentation for GitHub Actions.
#
# It does this by parsing `action.yml` and generating Markdown for the action name,
# description, and inputcs.

require 'optparse'

VERSION = File.read('VERSION').chomp

# The main logic
class Generate
  # Class methods
  class << self
    def run
      options = {}

      optparser = build_optparser(options)
      begin
        optparser.parse!
      rescue OptionParser::InvalidOption, OptionParser::MissingArgument
        puts $ERROR_INFO.to_s
        puts optparser
        exit
      end

      Generate.new(ARGV, options).run
    end

    def build_optparser(options)
      OptionParser.new do |opts|
        opts.banner = "Usage: #{__FILE__} [options]"

        opts.on('--version', 'Show the version') do
          options[:version] = true
        end
      end
    end
  end

  attr_reader :args, :options

  def initialize(args, options)
    @args = args
    @options = options
  end

  def run
    case
    when options[:version]
      display_version
    else
      generate
    end
  end

  def generate
  end


  def display_version
    puts "#{__FILE__} version #{VERSION}"
  end
end

Generate.run
