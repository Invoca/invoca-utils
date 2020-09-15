# frozen_string_literal: true

require_relative '../test_helper'
require_relative '../helpers/constant_overrides'

describe Invoca::Utils do
  include ConstantOverrides

  context "global namespace issues" do
    before do
      setup_constant_overrides
    end

    after do
      cleanup_constant_overrides
    end

    it "define Diff as Invoca::Utils::Diff" do
      expect(Invoca::Utils::Diff).to eq(::Diff)
    end

    it "define Diffable as Diffable" do
      expect(Invoca::Utils::Diffable).to eq(::Diffable)
    end

    context "when Diff is defined in the global namespace" do
      before do
        @class = Class.new
        set_test_const("Diff", @class)
        load 'invoca/utils.rb'
      end

      it "not define Diff as Invoca::Utils::Diff" do
        expect(@class).to eq(::Diff)
      end
    end

    context "when Diffable is defined in the global namespace" do
      before do
        @class = Class.new
        set_test_const("Diffable", @class)
        load 'invoca/utils.rb'
      end

      it "define Diffable as Invoca::Utils::Diffable" do
        expect(@class).to eq(::Diffable)
      end
    end
  end
end
