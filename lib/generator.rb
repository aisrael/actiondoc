# frozen_string_literal: true

require 'action'
require 'erb'
require 'ostruct'
require 'table_layouts'
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
    action = read_action_yml
    render_default_template(action)
  end

  def read_action_yml
    yaml = YAML.safe_load(File.read('action.yml')).deep_symbolize_keys
    inputs = yaml.fetch(:inputs, {}).map do |k, v|
      { name: k.to_s }.merge(v)
    end
    Action.new(*(yaml.values_at(:name, :description) + [inputs]))
  end

  def render_default_template(action)
    template_filename = File.join(TEMPLATES_DIR, 'default.erb')
    inputs_table = construct_inputs_table(action)
    template = ERB.new(File.read(template_filename), trim_mode: '-')
    model = TemplateModel.new(action, inputs_table)
    puts template.result(model.instance_eval { binding })
  end

  def construct_inputs_table(action)
    headers = Input.members.map(&:to_s).map(&:capitalize)
    data = action.inputs.map(&:values)
    TableLayouts::Nice.new(headers, data).layout
  end
end

INPUTS_SECTION_ERB = <<~ERB

  ## Inputs

  <% inputs_table.each do |row| -%>
  <%= "|" + row.join("|") + "|" %>
  <% end -%>
ERB

# For ERB binding
TemplateModel = Struct.new(:action, :inputs_table) do
  def inputs_section
    return if inputs_table.nil? || inputs_table.empty?

    ERB.new(INPUTS_SECTION_ERB, trim_mode: '-').result(binding)
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
