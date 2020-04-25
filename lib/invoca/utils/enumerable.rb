# frozen_string_literal: true

# Invoca ::Enumerable extensions
module Enumerable
  def build_hash(res = {})
    each do |x|
      pair = block_given? ? yield(x) : x
      res[pair.first] = pair.last if pair
    end
    res
  end

  class MultiSender

    undef_method(*(instance_methods.map { |m| m.to_s } - %w*__id__ __send__ object_id*))

    def initialize(enumerable, method)
      @enumerable = enumerable
      @method     = method
    end

    def method_missing(name, *args, &block)
      @enumerable.send(@method) { |x| x.send(name, *args, &block) }
    end

  end

  def *()
    MultiSender.new(self, :map)
  end
end
