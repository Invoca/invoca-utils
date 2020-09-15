# frozen_string_literal: true

require_relative '../../lib/invoca/utils/hash.rb'
require_relative '../spec_helper'

describe Hash do

  context 'select_hash' do
    it 'return a hash containing key/values identified by the block' do
      expect({ 1 => 2, 3 => 4, 6 => 5 }.select_hash { |key, value| key < value }).to eq({ 1 => 2, 3 => 4 })
    end

    it 'handle blocks that only check values' do
      expect({ 1 => 2, 3 => 4, 6 => 5 }.select_hash { |value| value != 2 }).to eq({ 3 => 4, 6 => 5 })
    end
  end

  context 'map_hash' do
    it 'return a hash containing values updated by the block' do
      expect({ 1 => 2, 3 => 4, 6 => 5 }.map_hash { |key, value| key < value }).to eq({ 1 => true, 3 => true, 6 => false })
    end

    it 'handle blocks that only receive values' do
      expect({ 1 => 2, 3 => 4, 6 => 5 }.map_hash { |value| value * 2 }).to eq({ 1 => 4, 3 => 8, 6 => 10 })
    end
  end

  context 'partition_hash' do
    it 'return two hashes, the first contains the pairs with matching keys, the second contains the rest' do
      expect( { 1 => 2, 3 => 4, 6 => 5 }.partition_hash([1, 3])).to eq([{ 1 => 2, 3 => 4 }, { 6 => 5 }])
    end

    it 'return two hashes, the first contains the pairs with identified by the block, the second contains the rest' do
      expect( { 1 => 2, 3 => 4, 6 => 5 }.partition_hash { |key, value| key < value }).to eq([{ 1 => 2, 3 => 4 }, { 6 => 5 }])
    end

    it 'handle no matches' do
      expect( { 1 => 2, 3 => 4, 6 => 5 }.partition_hash([100])).to eq([{}, { 1 => 2, 3 => 4, 6 => 5 }])
    end

    it 'handle all matches' do
      expect( { 1 => 2, 3 => 4, 6 => 5 }.partition_hash { |_key, _value| true }).to eq([{ 1 => 2, 3 => 4, 6 => 5 }, {}])
    end
  end

  context '- operator' do
    it 'return a hash with pairs removed that match the keys in rhs array' do
      expect({ 1 => 2, 3 => 4, 6 => 5 } - [1, 6]).to eq({ 3 => 4 })
    end

    it 'handle empty rhs array' do
      expect({ 1 => 2, 3 => 4, 6 => 5 } - []).to eq({ 1 => 2, 3 => 4, 6 => 5 })
    end

    it 'handle no matches in rhs array' do
      expect({ 1 => 2, 3 => 4, 6 => 5 } - [100, 600]).to eq({ 1 => 2, 3 => 4, 6 => 5 })
    end

    it 'handle all matches in rhs array' do
      expect({ 1 => 2, 3 => 4, 6 => 5 } - [1, 3, 6]).to eq({})
    end
  end

  context '& operator' do
    it 'return a hash with pairs removed that do NOT match the keys in rhs array' do
      expect({ 1 => 2, 3 => 4, 6 => 5 } & [1, 6]).to eq({ 1 => 2, 6 => 5 })
    end

    it 'handle empty rhs array' do
      expect({ 1 => 2, 3 => 4, 6 => 5 } & []).to eq({})
    end

    it 'handle no matches in rhs array' do
      expect({ 1 => 2, 3 => 4, 6 => 5 } & [100, 600]).to eq({})
    end

    it 'handle all matches in rhs array' do
      expect({ 1 => 2, 3 => 4, 6 => 5 } & [1, 3, 6]).to eq({ 1 => 2, 3 => 4, 6 => 5 })
    end
  end
end
