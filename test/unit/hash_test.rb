# frozen_string_literal: true

require_relative '../../lib/invoca/utils/hash.rb'
require_relative '../test_helper'

class HashTest < Minitest::Test

  context 'select_hash' do
    should 'return a hash containing key/values identified by the block' do
      assert_equal({ 1 => 2, 3 => 4 }, { 1 => 2, 3 => 4, 6 => 5 }.select_hash { |key, value| key < value })
    end

    should 'handle blocks that only check values' do
      assert_equal({ 3 => 4, 6 => 5 }, { 1 => 2, 3 => 4, 6 => 5 }.select_hash { |value| value != 2 })
    end
  end

  context 'map_hash' do
    should 'return a hash containing values updated by the block' do
      assert_equal({ 1 => true, 3 => true, 6 => false }, { 1 => 2, 3 => 4, 6 => 5 }.map_hash { |key, value| key < value })
    end

    should 'handle blocks that only receive values' do
      assert_equal({ 1 => 4, 3 => 8, 6 => 10 }, { 1 => 2, 3 => 4, 6 => 5 }.map_hash { |value| value * 2 })
    end
  end

  context 'partition_hash' do
    should 'return two hashes, the first contains the pairs with matching keys, the second contains the rest' do
      assert_equal([{ 1 => 2, 3 => 4 }, { 6 => 5 }], { 1 => 2, 3 => 4, 6 => 5 }.partition_hash([1,3]))
    end

    should 'return two hashes, the first contains the pairs with identified by the block, the second contains the rest' do
      assert_equal([{ 1 => 2, 3 => 4 }, { 6 => 5 }], { 1 => 2, 3 => 4, 6 => 5 }.partition_hash { |key, value| key < value })
    end

    should 'handle no matches' do
      assert_equal([{}, { 1 => 2, 3 => 4, 6 => 5 }], { 1 => 2, 3 => 4, 6 => 5 }.partition_hash([100]))
    end

    should 'handle all matches' do
      assert_equal([{ 1 => 2, 3 => 4, 6 => 5 }, {}], { 1 => 2, 3 => 4, 6 => 5 }.partition_hash { |key, value| true })
    end
  end

  context '- operator' do
    should 'return a hash with pairs removed that match the keys in rhs array' do
      assert_equal({ 3 => 4 }, { 1 => 2, 3 => 4, 6 => 5 } - [1, 6])
    end

    should 'handle empty rhs array' do
      assert_equal({ 1 => 2, 3 => 4, 6 => 5 }, { 1 => 2, 3 => 4, 6 => 5 } - [])
    end

    should 'handle no matches in rhs array' do
      assert_equal({ 1 => 2, 3 => 4, 6 => 5 }, { 1 => 2, 3 => 4, 6 => 5 } - [100, 600])
    end

    should 'handle all matches in rhs array' do
      assert_equal({}, { 1 => 2, 3 => 4, 6 => 5 } - [1, 3, 6])
    end
  end

  context '& operator' do
    should 'return a hash with pairs removed that do NOT match the keys in rhs array' do
      assert_equal({ 1 => 2, 6 => 5 }, { 1 => 2, 3 => 4, 6 => 5 } & [1, 6])
    end

    should 'handle empty rhs array' do
      assert_equal({}, { 1 => 2, 3 => 4, 6 => 5 } & [])
    end

    should 'handle no matches in rhs array' do
      assert_equal({}, { 1 => 2, 3 => 4, 6 => 5 } & [100, 600])
    end

    should 'handle all matches in rhs array' do
      assert_equal({ 1 => 2, 3 => 4, 6 => 5 }, { 1 => 2, 3 => 4, 6 => 5 } & [1, 3, 6])
    end
  end
end
