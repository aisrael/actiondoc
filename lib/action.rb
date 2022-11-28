# frozen_string_literal: true

Action = Struct.new(:name, :description, :inputs)

Input = Struct.new(:name, :description, :required, :default) do
  class << self
    def members_as_headers
      members.map(&:to_s).map(&:capitalize)
    end
  end
end
INPUTS_HEADERS = Input.members.map { |s| s.to_s.capitalize }.freeze
