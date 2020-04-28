# frozen_string_literal: true

require 'active_support/hash_with_indifferent_access'
require_relative '../../lib/invoca/utils/hash_with_indifferent_access.rb'
require_relative '../test_helper'

class HashWithIndifferentAccessTest < Minitest::Test

  context 'partition_hash' do
    setup do
      @hash_to_test = HashWithIndifferentAccess.new( 'one' => 2, three: 4, 'six' => 5 )
    end

    should 'return two hashes, the first contains the pairs with matching keys, the second contains the rest' do
      assert_equal([{ 'one' => 2, 'three' => 4 }, { 'six' => 5 }], @hash_to_test.partition_hash(['one', 'three']))
    end

    should 'return two hashes, the first contains the pairs with identified by the block, the second contains the rest' do
      assert_equal([{ 'one' => 2, 'three' => 4 }, { 'six' => 5 }], @hash_to_test.partition_hash { |key, value| ['one', 'three'].include?(key) })
    end

    should 'handle no matches' do
      assert_equal([{}, @hash_to_test], @hash_to_test.partition_hash([:not_found]))
    end

    should 'handle all matches' do
      assert_equal([@hash_to_test, {}], @hash_to_test.partition_hash { |key, value| true })
    end

    should 'handle symbols for key matching' do
      assert_equal([{ 'one' => 2, 'three' => 4 }, { 'six' => 5 }], @hash_to_test.partition_hash([:one, :three]))
    end

    should 'return HashWithIndifferentAccess objects' do
      matched, unmatched = @hash_to_test.partition_hash([:one, :three])
      assert(matched.is_a?(HashWithIndifferentAccess))
      assert(unmatched.is_a?(HashWithIndifferentAccess))
    end
  end

  context '- operator' do
    setup do
      @hash_to_test = HashWithIndifferentAccess.new( 'one' => 2, three: 4, 'six' => 5 )
    end

    should 'return a hash with pairs removed that match the keys in rhs array' do
      assert_equal({ 'three' => 4 }, @hash_to_test - ['one', 'six'])
    end

    should 'handle empty rhs array' do
      assert_equal(@hash_to_test, @hash_to_test - [])
    end

    should 'handle no matches in rhs array' do
      assert_equal(@hash_to_test, @hash_to_test - ['100', '600'])
    end

    should 'handle all matches in rhs array' do
      assert_equal({}, @hash_to_test - ['one', 'three', 'six'])
    end

    should 'handle symbols for key matching' do
      assert_equal({ 'six' => 5 }, @hash_to_test - [:one, :three])
    end

    should 'return HashWithIndifferentAccess object' do
      assert((@hash_to_test - [:one, :three]).is_a?(HashWithIndifferentAccess))
    end
  end

  context '& operator' do
    setup do
      @hash_to_test = HashWithIndifferentAccess.new( 'one' => 2, three: 4, 'six' => 5 )
    end

    should 'return a hash with pairs removed that do NOT match the keys in rhs array' do
      assert_equal({ 'one' => 2, 'six' => 5 }, @hash_to_test & ['one', 'six'])
    end

    should 'handle empty rhs array' do
      assert_equal({}, @hash_to_test & [])
    end

    should 'handle no matches in rhs array' do
      assert_equal({}, @hash_to_test & ['100', '600'])
    end

    should 'handle all matches in rhs array' do
      assert_equal(@hash_to_test, @hash_to_test & ['one', 'three', 'six'])
    end

    should 'handle symbols for key matching' do
      assert_equal({ 'one' => 2, 'three' => 4 }, @hash_to_test & [:one, :three])
    end

    should 'return HashWithIndifferentAccess object' do
      assert((@hash_to_test & [:one, :three]).is_a?(HashWithIndifferentAccess))
    end
  end
end
