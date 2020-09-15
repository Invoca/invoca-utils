# frozen_string_literal: true

require_relative '../spec_helper'

describe Invoca::Utils do
  context "exceptions" do
    context ".retry_on_exception" do
      it "default retries: to 1" do
        times = 0
        tries = []
        result = Invoca::Utils.retry_on_exception(ArgumentError) do |try|
          tries << try
          times += 1
        end
        expect(result).to eq(1)
        expect(tries).to eq([0])
      end

      context "when never raising an exception" do
        it "return result" do
          times = 0
          tries = []
          result = Invoca::Utils.retry_on_exception(ArgumentError, retries: 2) do |try|
            tries << try
            times += 1
            try == 0 and raise ArgumentError, '!!!'
            times
          end
          expect(result).to eq(2)
          expect(tries).to eq([0,1])
        end
      end

      context "when always raising an exception" do
        it "retry and finally raise" do
          tries = []
          expect do
            Invoca::Utils.retry_on_exception(ArgumentError, retries: 1) do |try|
              tries << try
              raise ArgumentError, "!!! #{try + 1}"
            end
          end.to raise_exception(ArgumentError, /!!! 2/)
          expect(tries).to eq([0,1])
        end
      end

      context "when raising but then succeeding" do
        it "retry and finally return result" do
          times = 0
          result = Invoca::Utils.retry_on_exception(ArgumentError, retries: 1) do
            times += 1
            if times == 1
              raise ArgumentError, "!!! #{times}"
            else
              times
            end
          end
          expect(result).to eq(2)
        end
      end

      context "when raising different exceptions (array notation) but then succeeding" do
        it "retry and finally return result" do
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
          expect(result).to eq(3)
          expect(tries).to eq([0, 1, 2])
        end
      end
    end
  end
end
