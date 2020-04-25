# frozen_string_literal: true

require_relative '../../lib/invoca/utils/array.rb'
require_relative '../test_helper'

class ArrayTest < Minitest::Test
  context '* operator' do
    should 'call the same method on each item in an array and return the results as an array' do
      assert_equal([4, 5, 5], ['some', 'short', 'words'].*.length)
    end

    should 'handle methods with arguments' do
      assert_equal(['om', 'ho', 'or'], ['some', 'short', 'words'].*.slice(1, 2))
    end

    should 'not alter normal behavior (multiplication) when there is a right hand side to the expression' do
      assert_equal(['some', 'short', 'words', 'some', 'short', 'words'], ['some', 'short', 'words'] * 2)
    end
  end
end
