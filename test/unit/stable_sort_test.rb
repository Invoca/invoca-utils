# frozen_string_literal: true

require_relative '../test_helper'

describe Enumerable do
  context "#stable_sort_by" do
    it "preserve the original order if all sort the same" do
      list_to_sort = [:b, :d, :c, :a, :e, :f]

      expect(list_to_sort.stable_sort_by { |c| 0 }).to eq(list_to_sort)
    end

    it "order by keys first and then position" do
      list_to_sort = [:b, :d, :c, :a, :e, :f]
      order = [:a, :b, :c]

      result = list_to_sort.stable_sort_by { |c| order.index(c) || order.length }
      expect(result).to eq([:a, :b, :c, :d, :e, :f])
    end

    it "order by keys only if needed" do
      list_to_sort = [:b, :d, :c, :a, :e, :f]
      result = list_to_sort.stable_sort_by { |c| c.to_s }
      expect(result).to eq([:a, :b, :c, :d, :e, :f])
    end
  end

  context "stable_sort" do
    it "preserve the original order if all sort the same" do
      list_to_sort = [:b, :d, :c, :a, :e, :f]

      expect(list_to_sort.stable_sort { |first, second| 0 }).to eq(list_to_sort)
    end

    it "order by keys first and then position" do
      list_to_sort = [:b, :d, :c, :a, :e, :f]
      order = [:a, :b, :c]

      result = list_to_sort.stable_sort do |first, second|
        first_pos = order.index(first) || order.length
        second_pos = order.index(second) || order.length
        first_pos <=> second_pos
      end

      expect(result).to eq([:a, :b, :c, :d, :e, :f])
    end

    it "order by keys only if needed" do
      list_to_sort = [:b, :d, :c, :a, :e, :f]
      result = list_to_sort.stable_sort{ |first, second| first.to_s <=> second.to_s }
      expect(result).to eq([:a, :b, :c, :d, :e, :f])
    end
  end
end
