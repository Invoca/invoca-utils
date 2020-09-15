# frozen_string_literal: true

require_relative '../../lib/invoca/utils/array.rb'
require_relative '../test_helper'

describe Array do
  context '* operator' do
    it 'call the same method on each item in an array and return the results as an array' do
      expect(['some', 'short', 'words'].*.length).to eq([4, 5, 5])
    end

    it 'handle methods with arguments' do
      expect(['some', 'short', 'words'].*.slice(1, 2)).to eq(['om', 'ho', 'or'])
    end

    it 'not alter normal behavior (multiplication) when there is a right hand side to the expression' do
      expect(['some', 'short', 'words'] * 2).to eq(['some', 'short', 'words', 'some', 'short', 'words'])
    end
  end
end
