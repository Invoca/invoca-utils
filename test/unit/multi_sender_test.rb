# frozen_string_literal: true

require_relative '../../lib/invoca/utils/multi_sender.rb'
require_relative '../test_helper'

describe Invoca::Utils::MultiSender do
  # create enumerable class for testing
  class LinkedList
    include Enumerable

    def initialize(head, tail = nil)
      @head, @tail = head, tail
    end

    def <<(item)
      LinkedList.new(item, self)
    end

    def inspect
      [@head, @tail].inspect
    end

    def each(&block)
      if block_given?
        block.call(@head)
        @tail&.each(&block)
      else
        to_enum(:each)
      end
    end
  end

  context 'with custom Enumerable' do
    before do
      linked_list = LinkedList.new('some') << 'short' << 'words'
      @multi_sender = Invoca::Utils::MultiSender.new(linked_list, :map)
    end

    it 'call the same method on each item in an Enumerable and return the results as an array' do
      expect(@multi_sender.length).to eq([5, 5, 4])
    end

    it 'handle methods with arguments' do
      expect(@multi_sender.slice(1, 2)).to eq(['or', 'ho', 'om'])
    end
  end

  context 'with built-in Array' do
    it 'call the same method on each item in an Array and return the results as an array' do
      multi_sender = Invoca::Utils::MultiSender.new(['some', 'short', 'words'], :map)
      expect(multi_sender.length).to eq([4, 5, 5])
    end
  end
end
