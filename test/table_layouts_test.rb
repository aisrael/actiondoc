# frozen_string_literal: true

require 'test_helper'

require 'action'
require 'minitest/autorun'
require 'table_layouts'

class TableLayoutsTest < Minitest::Test
  EMPTY_LAYOUT = [
    INPUTS_HEADERS.map { |s| " #{s} " },
    INPUTS_HEADERS.map { |s| '-' * (s.length + 2) }
  ].freeze

  def test_nice_layout_empty
    layout = TableLayouts::Nice.new(INPUTS_HEADERS, [])

    assert_equal(INPUTS_HEADERS.map(&:length), layout.find_max_column_widths)
    assert_equal(EMPTY_LAYOUT, layout.layout)
  end

  def test_nice_layout_one_short
    layout = TableLayouts::Nice.new(INPUTS_HEADERS, [['name']])

    assert_equal([4, 11, 8, 7], layout.find_max_column_widths)
    assert_equal(EMPTY_LAYOUT + [[' name ', '             ', '          ', '         ']], layout.layout)
  end

  def test_nice_layout_longer_first_column
    layout = TableLayouts::Nice.new(INPUTS_HEADERS, [['path-to-action-yml']])

    assert_equal([18, 11, 8, 7], layout.find_max_column_widths)
  end

  def test_nice_layout_one_longer
    layout = TableLayouts::Nice.new(INPUTS_HEADERS, [['path-to-action-yml', 'The path to the action.yml', nil]])

    assert_equal([18, 26, 8, 7], layout.find_max_column_widths)
  end

  def test_nice_layout_lots
    layout = TableLayouts::Nice.new(INPUTS_HEADERS,
                                    [
                                      ['some-input', 'Some input', nil, nil],
                                      ['required-input', 'Some required input', true, nil],
                                      ['input-with-default', 'Input with default', false, 'default value']
                                    ])

    assert_equal([18, 19, 8, 13], layout.find_max_column_widths)
  end
end
