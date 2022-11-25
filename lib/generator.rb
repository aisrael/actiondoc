# frozen_string_literal: true

require 'action'
require 'erb'
require 'ostruct'
require 'yaml'

TEMPLATES_DIR = File.expand_path('../templates', __dir__)

# The documentation generator class
class Generator
  attr_reader :args, :options, :padding

  # Initialize an instance of this `Generator` class
  def initialize(args, options)
    @args = args
    @options = options
    @padding = options.fetch(:padding, :nice)
  end

  def run
    yaml = read_action_yml
    inputs = yaml.fetch(:inputs, {}).map do |k, v|
      { name: k.to_s }.merge(v)
    end
    warn inputs.inspect
    action = Action.new(*(yaml.values_at(:name, :description) + [inputs]))
    render_default_template(action)
  end

  def read_action_yml
    YAML.safe_load(File.read('action.yml')).deep_symbolize_keys
  end

  def render_default_template(action)
    template_filename = File.join(TEMPLATES_DIR, 'default.erb')
    puts ERB.new(File.read(template_filename), trim_mode: '-').result(binding)
  end
end

# Monkey patch Hash
module HashExt
  def deep_symbolize_keys
    transform_keys(&:to_sym).transform_values do |v|
      case v
      when Hash
        v.deep_symbolize_keys
      when Array
        v.map { |e| e.is_a?(Hash) ? e.deep_symbolize_keys : e }
      else
        v
      end
    end
  end
end
Hash.include HashExt
