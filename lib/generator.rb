# frozen_string_literal: true

require 'action'
require 'erb'
require 'yaml'

TEMPLATES_DIR = File.expand_path('../templates', __dir__)

# The documentation generator class
class Generator
  attr_reader :args, :options

  # Initialize an instance of this `Generator` class
  def initialize(args, options)
    @args = args
    @options = options
  end

  def run
    yaml = read_action_yml
    action = Action.new(name: yaml['name'], description: yaml['description'])
    render_default_template(action)
  end

  def read_action_yml
    YAML.safe_load(File.read('action.yml'))
  end

  def render_default_template(action)
    template_filename = File.join(TEMPLATES_DIR, 'default.erb')
    puts ERB.new(File.read(template_filename), trim_mode: '-').result(binding)
  end
end
