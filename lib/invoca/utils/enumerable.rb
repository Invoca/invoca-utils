# frozen_string_literal: true

require_relative './multi_sender'

# Invoca ::Enumerable extensions
module Enumerable
  def map_and_find(not_found=nil)
    each do |x|
      val = yield(x)
      return val if val
    end
    not_found
  end

  def map_with_index(res=[])
    each_with_index do |x, i|
      res << yield(x, i)
    end
    res
  end

  def build_hash(res={})
    each do |x|
      pair = block_given? ? yield(x) : x
      res[pair.first] = pair.last if pair
    end
    res
  end

  def map_hash(res={})
    each do |x|
      v = yield x
      res[x] = v
    end
    res
  end

  def *
    Invoca::Utils::MultiSender.new(self, :map)
  end
end
