# frozen_string_literal: true

require 'set'
require_relative '../../lib/invoca/utils/enumerable.rb'
require_relative '../test_helper'

describe Enumerable do

  context 'map_and_find' do
    it 'return the mapped value of the first match' do
      expect([1, 2, 3, 4].map_and_find { |v| 'FOUND 3' if v == 3 }).to eq('FOUND 3')
    end

    it 'return the mapped value of the first match, even if there are multiple matches' do
      expect([1, 2, 3, 4].map_and_find { |v| "FOUND #{v}" if v > 2 }).to eq('FOUND 3')
    end

    it 'return the provided argument if the value is not found' do
      expect([1, 2, 3, 4].map_and_find('NOT FOUND') { |v| "FOUND 6" if v == 6 }).to eq('NOT FOUND')
    end

    it 'return nil if the value is not found and no argument is provided' do
      expect([1, 2, 3, 4].map_and_find { |v| "FOUND 6" if v == 6 }).to be_nil
    end
  end

  context 'map_with_index' do
    it 'call the block with the value and index' do
      expect([10, 20, 30, 40].map_with_index { |v, index| v + index }).to eq([10, 21, 32, 43])
    end

    it 'assumulate into the provided enumerable' do
      expect([10, 20, 30, 40].map_with_index([1]) { |v, index| v + index }).to eq([1, 10, 21, 32, 43])
    end
  end

  context 'map_hash' do
    it 'convert enumerables into a hash using the value for key and the map result as the hash value' do
      expect([1, 2, 3].map_hash { |v| v + 10  }).to eq({ 1 => 11, 2 => 12, 3 => 13 })
    end

    it 'includes nils returned from map' do
      expect([1, 2, 3].map_hash { |v| v + 10 unless v == 2  }).to eq({ 1 => 11, 2 => nil, 3 => 13 })
    end
  end

  context 'build_hash' do
    it 'convert arrays of [key, value] to a hash of { key => value }' do
      expect(['some', 'short', 'words'].build_hash { |s| [s, s.length] }).to eq({ 'some' => 4, 'short' => 5, 'words' => 5 })
    end

    it 'ignore nils returned from map' do
      expect(['some', 'short', 'words'].build_hash { |s|  s == 'short' ? nil : [s, s.length] }).to eq({ 'some' => 4, 'words' => 5 })
    end

    # these seem like erroneous behavior, but, they have been left as-is for backward compatibility with hobosupport::Enumerable::build_hash

    it 'convert arrays of [single_value] to a hash of { single_value => single_value }' do
      expect(['some', 'short', 'words'].build_hash { |s| s == 'short' ? [s] : [s, s.length] }).to eq({ 'some' => 4, 'short' => 'short', 'words' => 5 })
    end

    it 'convert arrays of [first, ..., last] to a hash of { first => last }' do
      expect(['some', 'short', 'words'].build_hash { |s| s == 'short' ? [s, 'two', 'three'] : [s, s.length] }).to eq({ 'some' => 4, 'short' => 'three', 'words' => 5 })
    end

    it 'convert empty arrays to a hash of { nil => nil }' do
      expect(['some', 'short', 'words'].build_hash { |s| s == 'short' ? [] : [s, s.length] }).to eq({ 'some' => 4, nil => nil, 'words' => 5 })
    end
  end

  context '* operator' do
    it 'call the same method on each item in an Set and return the results as an array' do
      expect(Set['some', 'short', 'words'].*.length).to eq([4, 5, 5])
    end

    it 'call the same method on each item in an Hash and return the results as an array' do
      expect({ key1: 'value1', key2: 'value2' }.*.join(':')).to eq(['key1:value1', 'key2:value2'])
    end
  end
end
