# frozen_string_literal: true

# A plain 'ole Ruby object to hold an Action's data, used for rendering the default templates
class Action
  attr_reader :name, :description
  def initialize(name:, description:)
    @name = name
    @description = description
  end
end
