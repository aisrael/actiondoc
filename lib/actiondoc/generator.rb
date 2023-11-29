# frozen_string_literal: true

require 'action'
require 'erb'
require 'ostruct'
require 'table_layouts'
require 'yaml'

TEMPLATES_DIR = File.expand_path('templates', __dir__)

module ActionDoc
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
      check_action_yml
      action = read_action_yml
      template_filename = options[:template] || File.join(TEMPLATES_DIR, 'default.erb')
      render_template(template_filename, action)
    end

    def check_action_yml
      @path_to_action_yml = @args.first || 'action.yml'
      return if File.readable?(@path_to_action_yml)

      puts "#{@path_to_action_yml} not found! Aborting..."
      exit 1
    end

    def read_action_yml
      yaml = YAML.safe_load(File.read(@path_to_action_yml)).deep_symbolize_keys
      inputs = yaml.fetch(:inputs, {}).map do |k, v|
        Input.new(k, v[:description], v[:required] ? 'Required' : 'No', v[:default])
      end
      Action.new(*(yaml.values_at(:name, :description) + [inputs]))
    end

    def render_template(template_filename, action)
      inputs_table = construct_inputs_table(action)
      template = ERB.new(File.read(template_filename), trim_mode: '-')
      model = TemplateModel.new(action, inputs_table)
      puts template.result(model.instance_eval { binding })
    end

    def construct_inputs_table(action)
      return unless action.inputs && !action.inputs.empty?

      TableLayouts::Nice.new(Input.members_as_headers, action.inputs).layout
    end
  end

  INPUTS_SECTION_ERB = <<~ERB
    ## Inputs

    <% inputs_table.each do |row| -%>
    <%= "|" + row.join("|") + "|" %>
    <% end -%>
  ERB

  NO_INPUTS = <<~NO_INPUTS

    ## Inputs

    This action has no inputs.
  NO_INPUTS

  # For ERB binding
  TemplateModel = Struct.new(:action, :inputs_table) do
    def inputs_section
      return NO_INPUTS if inputs_table.nil? || inputs_table.empty?

      ERB.new(INPUTS_SECTION_ERB, trim_mode: '-').result(binding)
    end
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
