# frozen_string_literal: true

require_relative '../test_helper'

class ExceptionsTest < Minitest::Test
  context "exceptions" do
    context ".retry_on_exception" do
      should "default retries: to 1" do
        times = 0
        tries = []
        result = Invoca::Utils.retry_on_exception(ArgumentError) do |try|
          tries << try
          times += 1
        end
        assert_equal 1, result
        assert_equal [0], tries
      end

      context "when never raising an exception" do
        should "return result" do
          times = 0
          tries = []
          result = Invoca::Utils.retry_on_exception(ArgumentError, retries: 2) do |try|
            tries << try
            times += 1
            try == 0 and raise ArgumentError, '!!!'
            times
          end
          assert_equal 2, result
          assert_equal [0, 1], tries
        end
      end

      context "when always raising an exception" do
        should "retry and finally raise" do
          tries = []
          assert_raises(ArgumentError, /!!! 2/) do
            Invoca::Utils.retry_on_exception(ArgumentError, retries: 1) do |try|
              tries << try
              raise ArgumentError, "!!! #{try + 1}"
            end
          end
          assert_equal [0, 1], tries
        end
      end

      context "when raising but then succeeding" do
        should "retry and finally return result" do
          times = 0
          result = Invoca::Utils.retry_on_exception(ArgumentError, retries: 1) do
            times += 1
            if times == 1
              raise ArgumentError, "!!! #{times}"
            else
              times
            end
          end
          assert_equal 2, result
        end
      end

      context "when raising different exceptions (array notation) but then succeeding" do
        should "retry and finally return result" do
          times = 0
          tries = []
          result = Invoca::Utils.retry_on_exception([ArgumentError, RuntimeError], retries: 2) do |try|
            tries << try
            times += 1
            case times
            when 1
              raise ArgumentError, "!!! #{times}"
            when 2
              raise RuntimeError, "!!! #{times}"
            else
              times
            end
          end
          assert_equal 3, result
          assert_equal [0, 1, 2], tries
        end
      end
    end
  end
end
