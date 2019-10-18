require_relative '../test_helper'
require_relative '../helpers/constant_overrides'

class UtilsTest < Minitest::Test
  include ConstantOverrides

  context "global namespace issues" do
    setup do
      setup_constant_overrides
    end

    teardown do
      cleanup_constant_overrides
    end

    should "define Diff as Invoca::Utils::Diff" do
      assert_equal ::Diff, Invoca::Utils::Diff
    end

    should "define Diffable as Diffable" do
      assert_equal ::Diffable, Invoca::Utils::Diffable
    end

    context "when Diff is defined in the global namespace" do
      setup do
        @class = Class.new
        set_test_const("Diff", @class)
        load 'invoca/utils.rb'
      end

      should "not define Diff as Invoca::Utils::Diff" do
        assert_equal ::Diff, @class
      end
    end

    context "when Diffable is defined in the global namespace" do
      setup do
        @class = Class.new
        set_test_const("Diffable", @class)
        load 'invoca/utils.rb'
      end

      should "define Diffable as Invoca::Utils::Diffable" do
        assert_equal ::Diffable, @class
      end
    end
  end
end
