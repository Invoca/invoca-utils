# frozen_string_literal: true

require_relative '../spec_helper'

describe Invoca::Utils do
  it "does not define Diff in the global namespace" do
    expect(Object.const_defined?(:Diff)).to be(false)
  end

  it "does not define Diffable in the global namespace" do
    expect(Object.const_defined?(:Diffable)).to be(false)
  end
end
