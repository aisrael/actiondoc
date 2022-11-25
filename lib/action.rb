# frozen_string_literal: true

Action = Struct.new(:name, :description, :inputs)

Input = Struct.new(:name, :description, :required, :default)
INPUTS_HEADERS = Input.members.map { |s| s.to_s.capitalize }.freeze
