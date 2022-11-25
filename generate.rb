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

BASE_FILENAME = File.basename(__FILE__)
VERSION = File.read(File.expand_path('VERSION', __dir__)).chomp

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
        opts.banner = "Usage: #{BASE_FILENAME} [options]"

        opts.on('--version', 'Show the version') do
          options[:version] = true
        end
        opts.on('--help', 'Display this help text') do
          puts opts
        end
      end
    end
  end

  attr_reader :args, :options

  # Initialize an instance of this `Generate` class
  def initialize(args, options)
    @args = args
    @options = options
  end

  # The 'main' entrypoint
  def run
    if options[:version]
      display_version
    else
      generate
    end
  end

  # Generate the documentation
  def generate; end

  # Print out the version (in the VERSION file)
  def display_version
    puts "#{BASE_FILENAME} version #{VERSION}"
  end
end

Generate.run
