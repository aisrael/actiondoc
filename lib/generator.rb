# frozen_string_literal: true

require 'action'
require 'erb'
require 'ostruct'
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
    inputs = yaml.fetch(:inputs, {}).map do |k, v|
      v.merge({ name: k.to_s })
    end
    action = Action.new(*(yaml.values_at(:name, :description) + [inputs]))
    render_default_template(action)
  end

  def read_action_yml
    deep_symbolize_keys(YAML.safe_load(File.read('action.yml')))
  end

  def render_default_template(action)
    template_filename = File.join(TEMPLATES_DIR, 'default.erb')
    puts ERB.new(File.read(template_filename), trim_mode: '-').result(binding)
  end
end

def deep_symbolize_keys(obj)
  case obj
  when Hash
    obj.transform_keys(&:to_sym).transform_values { |v| deep_symbolize_keys(v) }
  when Array
    obj.map { |e| deep_symbolize_keys(e) }
  else
    obj
  end
end
