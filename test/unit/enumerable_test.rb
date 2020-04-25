# frozen_string_literal: true

require 'set'
require_relative '../../lib/invoca/utils/enumerable.rb'
require_relative '../test_helper'

class EnumerableTest < Minitest::Test

  context 'build_hash' do
    should 'convert arrays of two items to hash key/value pairs' do
      assert_equal({ 'some' => 4, 'words' => 5 }, ['some', 'short', 'words'].build_hash { |s| [s, s.length] unless s == 'short' })
    end

    should 'ignore nils returned from map' do
      assert_equal({ 'some' => 4, 'words' => 5 }, ['some', 'short', 'words'].build_hash { |s|  s == 'short' ? nil : [s, s.length] })
    end

    # these seem like erroneous behavior, but, they have been left as-is for backward compatibility with hobosupport::Enumerable::build_hash

    should 'convert arrays with one item by using the same value for key and value' do
      assert_equal({ 'some' => 4, 'short' => 'short', 'words' => 5 }, ['some', 'short', 'words'].build_hash { |s| s == 'short' ? [s] : [s, s.length] })
    end

    should 'convert arrays with more than two items by using the last item as the value' do
      assert_equal({ 'some' => 4, 'short' => 'three', 'words' => 5 }, ['some', 'short', 'words'].build_hash { |s| s == 'short' ? [s, 'two', 'three'] : [s, s.length] })
    end

    should 'convert empty arrays into nil keys and values' do
      assert_equal({ 'some' => 4, nil => nil, 'words' => 5 }, ['some', 'short', 'words'].build_hash { |s| s == 'short' ? [] : [s, s.length] })
    end
  end

  context '* operator' do
    should 'call the same method on each item in an enumeration and return the results as an array' do
      assert_equal([4, 5, 5], Set['some', 'short', 'words'].*.length)
    end
  end
end