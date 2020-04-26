# frozen_string_literal: true

require_relative './multi_sender'

# Invoca ::Enumerable extensions
module Enumerable
  def build_hash(res = {})
    each do |x|
      pair = block_given? ? yield(x) : x
      res[pair.first] = pair.last if pair
    end
    res
  end

  def *()
    Invoca::Utils::MultiSender.new(self, :map)
  end
end
