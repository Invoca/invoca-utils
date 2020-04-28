# frozen_string_literal: true

require_relative './multi_sender'

# Invoca ::Array extensions
# TODO: Once the hobo_support gem is no longer used by any of our code, use prepend instead of alias
class Array

  alias_method :original_multiply_operator, :* # rubocop:disable Style/Alias

  def *(rhs = nil)
    if rhs
      original_multiply_operator(rhs)
    else
      Invoca::Utils::MultiSender.new(self, :map)
    end
  end
end
