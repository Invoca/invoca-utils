# frozen_string_literal: true

module Invoca
  module Utils
    class MultiSender
      undef_method(*(instance_methods - [:__id__, :__send__, :object_id]))

      def initialize(enumerable, method)
        @enumerable = enumerable
        @method     = method
      end

      # rubocop:disable Style/MethodMissingSuper
      # rubocop:disable Style/MissingRespondToMissing
      def method_missing(name, *args, &block)
        @enumerable.send(@method) { |x| x.send(name, *args, &block) }
      end
      # rubocop:enable Style/MethodMissingSuper
      # rubocop:enable Style/MissingRespondToMissing
    end
  end
end
