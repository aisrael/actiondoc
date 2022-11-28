# frozen_string_literal: true

require 'actiondoc/version'
require 'generator'
require 'optparse'

# The ActionDoc module
module ActionDoc
  class Error < StandardError; end

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

      if options[:version]
        display_version
      else
        Generator.new(ARGV, options).run
      end
    end

    def build_optparser(options)
      OptionParser.new do |opts|
        opts.banner = 'Usage: actiondoc [options]'

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
