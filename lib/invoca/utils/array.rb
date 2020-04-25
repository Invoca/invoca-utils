# frozen_string_literal: true

require_relative './multi_sender'

# Invoca ::Array extensions
module Invoca
  module Utils
    module ArrayMultiply
      def *(rhs = nil)
        if rhs
          super
        else
          Invoca::Utils::MultiSender.new(self, :map)
        end
      end
    end
  end
end

Array.prepend(Invoca::Utils::ArrayMultiply)

