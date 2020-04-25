# frozen_string_literal: true

require_relative './enumerable.rb'

# Invoca ::Array extensions
class Array
  alias_method :multiply, :*

  def *(rhs = nil)
    if rhs
      multiply(rhs)
    else
      Enumerable::MultiSender.new(self, :map)
    end
  end
end
