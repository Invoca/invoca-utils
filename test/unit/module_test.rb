# frozen_string_literal: true

# must require active_support's alias_method_chain first, to ensure that our module monkey patches it
require 'active_support/core_ext/module/aliasing'
require_relative '../../lib/invoca/utils/module.rb'
require_relative '../test_helper'

describe Module do
  class NumberFun
    def self.around_filter(around_method, method_names)
      method_names.each do |meth|
        define_method("#{meth}_with_around_filter") do |*args|
          send(around_method, *args) do |*ar_args|
            send("#{meth}_without_around_filter", *ar_args)
          end
        end

        alias_method_chain meth, :around_filter
      end
    end

    def increment_filter(num)
      yield(num + 1)
    end

    def number_printer(num)
      num
    end

    around_filter :increment_filter, [:number_printer]
    around_filter :increment_filter, [:number_printer]
  end

  context 'alias_method_chain' do
    it 'not cause infinite recursion when double aliasing the same method' do
      expect(NumberFun.new.number_printer(3)).to eq(4)
    end
  end
end
