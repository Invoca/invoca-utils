# frozen_string_literal: true

require_relative '../../lib/invoca/utils/multi_sender.rb'
require_relative '../test_helper'

class MultiSenderTest < Minitest::Test
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

  context 'MultiSender' do
    context 'with custom Enumerable' do
      setup do
        linked_list = LinkedList.new('some') << 'short' << 'words'
        @multi_sender = Invoca::Utils::MultiSender.new(linked_list, :map)
      end

      should 'call the same method on each item in an Enumerable and return the results as an array' do
        assert_equal([5, 5, 4], @multi_sender.length)
      end

      should 'handle methods with arguments' do
        assert_equal(['or', 'ho', 'om'], @multi_sender.slice(1, 2))
      end
    end

    context 'with built-in Array' do
      should 'call the same method on each item in an Array and return the results as an array' do
        multi_sender = Invoca::Utils::MultiSender.new(['some', 'short', 'words'], :map)
        assert_equal([4, 5, 5], multi_sender.length)
      end
    end
  end
end
