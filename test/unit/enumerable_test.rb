# frozen_string_literal: true

require 'set'
require_relative '../../lib/invoca/utils/enumerable.rb'
require_relative '../test_helper'

class EnumerableTest < Minitest::Test

  context 'map_and_find' do
    should 'return the mapped value of the first match' do
      assert_equal('FOUND 3', [1, 2, 3, 4].map_and_find { |v| 'FOUND 3' if v == 3 })
    end

    should 'return the mapped value of the first match, even if there are multiple matches' do
      assert_equal('FOUND 3', [1, 2, 3, 4].map_and_find { |v| "FOUND #{v}" if v > 2 })
    end

    should 'return the provided argument if the value is not found' do
      assert_equal('NOT FOUND', [1, 2, 3, 4].map_and_find('NOT FOUND') { |v| "FOUND 6" if v == 6 })
    end

    should 'return nil if the value is not found and no argument is provided' do
      assert_nil([1, 2, 3, 4].map_and_find { |v| "FOUND 6" if v == 6 })
    end
  end

  context 'map_with_index' do
    should 'call the block with the value and index' do
      assert_equal([10, 21, 32, 43], [10, 20, 30, 40].map_with_index { |v, index| v + index })
    end

    should 'assumulate into the provided enumerable' do
      assert_equal([1, 10, 21, 32, 43], [10, 20, 30, 40].map_with_index([1]) { |v, index| v + index })
    end
  end

  context 'map_hash' do
    should 'convert enumerables into a hash using the value for key and the map result as the hash value' do
      assert_equal({ 1 => 11, 2 => 12, 3 => 13 }, [1, 2, 3].map_hash { |v| v + 10  })
    end

    should 'includes nils returned from map' do
      assert_equal({ 1 => 11, 2 => nil, 3 => 13 }, [1, 2, 3].map_hash { |v| v + 10 unless v == 2  })
    end
  end

  context 'build_hash' do
    should 'convert arrays of [key, value] to a hash of { key => value }' do
      assert_equal({ 'some' => 4, 'short' => 5, 'words' => 5 }, ['some', 'short', 'words'].build_hash { |s| [s, s.length] })
    end

    should 'ignore nils returned from map' do
      assert_equal({ 'some' => 4, 'words' => 5 }, ['some', 'short', 'words'].build_hash { |s|  s == 'short' ? nil : [s, s.length] })
    end

    # these seem like erroneous behavior, but, they have been left as-is for backward compatibility with hobosupport::Enumerable::build_hash

    should 'convert arrays of [single_value] to a hash of { single_value => single_value }' do
      assert_equal({ 'some' => 4, 'short' => 'short', 'words' => 5 }, ['some', 'short', 'words'].build_hash { |s| s == 'short' ? [s] : [s, s.length] })
    end

    should 'convert arrays of [first, ..., last] to a hash of { first => last }' do
      assert_equal({ 'some' => 4, 'short' => 'three', 'words' => 5 }, ['some', 'short', 'words'].build_hash { |s| s == 'short' ? [s, 'two', 'three'] : [s, s.length] })
    end

    should 'convert empty arrays to a hash of { nil => nil }' do
      assert_equal({ 'some' => 4, nil => nil, 'words' => 5 }, ['some', 'short', 'words'].build_hash { |s| s == 'short' ? [] : [s, s.length] })
    end
  end

  context '* operator' do
    should 'call the same method on each item in an Set and return the results as an array' do
      assert_equal([4, 5, 5], Set['some', 'short', 'words'].*.length)
    end

    should 'call the same method on each item in an Hash and return the results as an array' do
      assert_equal(['key1:value1', 'key2:value2'], { key1: 'value1', key2: 'value2' }.*.join(':'))
    end
  end
end
