# frozen_string_literal: true

Action = Struct.new(:name, :description, :inputs)
Input = Struct.new(:name, :description, :required, :default)
