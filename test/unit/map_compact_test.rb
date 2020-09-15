# frozen_string_literal: true

require_relative '../test_helper'

describe Enumerable do
  it "map_compact" do
    expect([1, 2, nil, 3, 4].map_compact { |item| item**2 if (nil == item ? nil : item.odd?) }).to eq([1, 9])
  end

  it "map_compact to empty if nothing matches" do
    expect({:a => 'aaa', :b => 'bbb'}.map_compact { |key, value| value if key == :c }).to eq([])
  end

  it "map_compact a hash" do
    expect({:a => 'aaa', :b => 'bbb'}.map_compact { |key, value| value if key == :b }).to eq(['bbb'])
  end

  it "map_compact empty collection" do
    expect([].map_compact { |item| true }).to eq([])
  end

  it "not map_compact false" do
    expect([nil, false].map_compact { |a| a }).to eq([false])
  end
end
