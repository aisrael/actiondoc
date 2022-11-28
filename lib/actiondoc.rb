# frozen_string_literal: true

require 'actiondoc/generator'
require 'actiondoc/version'
require 'optparse'

# The ActionDoc CLI
module ActionDoc
  class Error < StandardError; end

  class << self
    # The main CLI entrypoint
    def run
      options = parse_options

      if options[:version]
        display_version
      else
        ActionDoc::Generator.new(ARGV, options).run
      end
    end

    # Builds the OptionParser and parses the options
    def parse_options
      options = {}

      optparser = build_optparser(options)
      begin
        optparser.parse!
      rescue OptionParser::InvalidOption, OptionParser::MissingArgument
        puts $ERROR_INFO.to_s
        puts optparser
        exit
      end

      options
    end

    # Builds and returns the OptionParser
    def build_optparser(options)
      OptionParser.new do |opts|
        opts.banner = 'Usage: actiondoc [options]'

        opts.on('--template=TEMPLATE_FILENAME', '-t=TEMPLATE_FILENAME', 'The template to use') do |template_filename|
          options[:template] = template_filename
        end
        opts.on('--version', 'Show the version') do
          options[:version] = true
        end
        opts.on('--help', 'Display this help text') do
          puts opts
        end
      end
    end

    # Print out the version (in the VERSION file)
    def display_version
      puts "actiondoc v#{ActionDoc::VERSION}"
    end
  end
end
