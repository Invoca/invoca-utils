# frozen_string_literal: true

require 'active_support/hash_with_indifferent_access'
require_relative '../../lib/invoca/utils/hash_with_indifferent_access.rb'
require_relative '../test_helper'

describe HashWithIndifferentAccess do

  context 'partition_hash' do
    before do
      @hash_to_test = HashWithIndifferentAccess.new('one' => 2, :three => 4, 'six' => 5)
    end

    it 'return two hashes, the first contains the pairs with matching keys, the second contains the rest' do
      expect(@hash_to_test.partition_hash(['one', 'three'])).to eq([{ 'one' => 2, 'three' => 4 }, { 'six' => 5 }])
    end

    it 'return two hashes, the first contains the pairs with identified by the block, the second contains the rest' do
      expect(@hash_to_test.partition_hash { |key, _value| ['one', 'three'].include?(key) }).to eq([{ 'one' => 2, 'three' => 4 }, { 'six' => 5 }])
    end

    it 'handle no matches' do
      expect(@hash_to_test.partition_hash([:not_found])).to eq([{}, @hash_to_test])
    end

    it 'handle all matches' do
      expect(@hash_to_test.partition_hash { |_key, _value| true }).to eq([@hash_to_test, {}])
    end

    it 'handle symbols for key matching' do
      expect(@hash_to_test.partition_hash([:one, :three])).to eq([{ 'one' => 2, 'three' => 4 }, { 'six' => 5 }])
    end

    it 'return HashWithIndifferentAccess objects' do
      matched, unmatched = @hash_to_test.partition_hash([:one, :three])
      expect(matched.is_a?(HashWithIndifferentAccess)).to be_truthy
      expect(unmatched.is_a?(HashWithIndifferentAccess)).to be_truthy
    end
  end

  context '- operator' do
    before do
      @hash_to_test = HashWithIndifferentAccess.new('one' => 2, :three => 4, 'six' => 5)
    end

    it 'return a hash with pairs removed that match the keys in rhs array' do
      expect(@hash_to_test - ['one', 'six']).to eq({ 'three' => 4 })
    end

    it 'handle empty rhs array' do
      expect(@hash_to_test - []).to eq(@hash_to_test)
    end

    it 'handle no matches in rhs array' do
      expect(@hash_to_test - ['100', '600']).to eq(@hash_to_test)
    end

    it 'handle all matches in rhs array' do
      expect(@hash_to_test - ['one', 'three', 'six']).to eq({})
    end

    it 'handle symbols for key matching' do
      expect(@hash_to_test - [:one, :three]).to eq({ 'six' => 5 })
    end

    it 'return HashWithIndifferentAccess object' do
      expect((@hash_to_test - [:one, :three]).is_a?(HashWithIndifferentAccess)).to be_truthy
    end
  end

  context '& operator' do
    before do
      @hash_to_test = HashWithIndifferentAccess.new('one' => 2, :three => 4, 'six' => 5)
    end

    it 'return a hash with pairs removed that do NOT match the keys in rhs array' do
      expect(@hash_to_test & ['one', 'six']).to eq({ 'one' => 2, 'six' => 5 })
    end

    it 'handle empty rhs array' do
      expect(@hash_to_test & []).to eq({})
    end

    it 'handle no matches in rhs array' do
      expect(@hash_to_test & ['100', '600']).to eq({})
    end

    it 'handle all matches in rhs array' do
      expect(@hash_to_test & ['one', 'three', 'six']).to eq(@hash_to_test)
    end

    it 'handle symbols for key matching' do
      expect(@hash_to_test & [:one, :three]).to eq({ 'one' => 2, 'three' => 4 })
    end

    it 'return HashWithIndifferentAccess object' do
      expect((@hash_to_test & [:one, :three]).is_a?(HashWithIndifferentAccess)).to be_truthy
    end
  end
end
