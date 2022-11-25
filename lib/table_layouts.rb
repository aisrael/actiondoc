# frozen_string_literal: true

# Table layouts
module TableLayouts
  # Nice layout
  class Nice
    def initialize(headers, data)
      @headers = headers
      @data = data
    end

    def find_max_column_widths
      all = [@headers] + @data
      longest_row = all.inject(0) { |max, row| [row.length, max].max }
      init = Array.new(longest_row, 0)
      all.inject(init) do |memo, row|
        memo.zip(row.map(&:to_s).map(&:length)).map { |pair| pair.compact.max }
      end
    end

    def layout
      max_column_widths = find_max_column_widths
      padded_column_widths = max_column_widths.map { |w| w + 2 }
      [pad_row(padded_column_widths, @headers), generate_separators(padded_column_widths)] + @data.map do |row|
        pad_row(padded_column_widths, row)
      end
    end

    def pad_row(padded_column_widths, row)
      padded_column_widths.zip(row).map do |width, col|
        " #{col}".ljust(width)
      end
    end

    def generate_separators(widths)
      widths.map { |width| '-' * width }
    end
  end
end
