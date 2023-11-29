# frozen_string_literal: true

require 'action'
require 'erb'
require 'ostruct'
require 'table_layouts'
require 'yaml'

DEFAULT_TEMPLATE = <<~ERB
  <%= action.name %>
  ====

  <%= action.description %>

  <%= inputs_section -%>
ERB

TEMPLATE_WITHOUT_INPUTS = <<~ERB
  <%= action.name %>
  ====

  <%= action.description %>

  ## Inputs

  This action has no inputs.
ERB

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
      template = read_template(action)
      render_template(template, action)
    end

    def read_template(action)
      options_template = options[:template]
      if options_template
        unless File.readable?(options_template)
          warn "Template file #{options_template} not found! Aborting..."
          exit 1
        end
        ERB.new(File.read(options_template), trim_mode: '-')
      elsif action.inputs && !action.inputs.empty?
        ERB.new(DEFAULT_TEMPLATE, trim_mode: '-')
      else
        ERB.new(TEMPLATE_WITHOUT_INPUTS, trim_mode: '-')
      end
    end

    def check_action_yml
      @path_to_action_yml = @args.first || 'action.yml'
      return if File.readable?(@path_to_action_yml)

      warn "#{@path_to_action_yml} not found! Aborting..."
      exit 1
    end

    def read_action_yml
      yaml = YAML.safe_load(File.read(@path_to_action_yml)).deep_symbolize_keys
      inputs = yaml.fetch(:inputs, {}).map do |k, v|
        Input.new(k, v[:description].chomp, v[:required] ? 'Required' : 'No', v[:default])
      end
      Action.new(yaml[:name], yaml[:description].chomp, inputs)
    end

    def render_template(template, action)
      inputs_table = construct_inputs_table(action)
      model = TemplateModel.new(action, inputs_table)
      puts template.result(model.instance_eval { binding })
    end

    def construct_inputs_table(action)
      return unless action.inputs && !action.inputs.empty?

      TableLayouts::Nice.new(Input.members_as_headers, action.inputs).layout
    end
  end

  # For ERB binding
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
