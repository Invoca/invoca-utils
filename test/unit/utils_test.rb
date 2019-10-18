require_relative '../test_helper'

class UtilsTest < Minitest::Test
  context "global namespace issues" do
    setup do
      setup_constant_overrides
    end

    teardown do
      cleanup_constant_overrides
    end

    context "when Diff is defined in the global namespace" do
      setup do
        set_test_const("Diff", Class.new)
        load 'invoca/utils.rb'
      end

      should "not define Diff as Invoca::Utils::Diff" do
        refute_equal ::Diff, Invoca::Utils::Diff
      end
    end

    context "when Diff is not defined in the global namespace" do
      setup do
        load 'invoca/utils.rb'
      end

      should "define Diff as Invoca::Utils::Diff" do
        assert_equal ::Diff, Invoca::Utils::Diff
      end
    end

    context "when Diffable is defined in the global namespace" do
      setup do
        set_test_const("Diffable", Class.new)
        load 'invoca/utils.rb'
      end

      should "define Diffable as Invoca::Utils::Diffable" do
        refute_equal ::Diffable, Invoca::Utils::Diffable
      end
    end

    context "when Diffable is not defined in the global namespace" do
      setup do
        load 'invoca/utils.rb'
      end

      should "define Diffable as Diffable" do
        assert_equal ::Diffable, Invoca::Utils::Diffable
      end
    end
  end
end

def setup_constant_overrides
  @constant_overrides = []
end

def cleanup_constant_overrides
  @constant_overrides.reverse.each do |parent_module, k, v|
    silence_warnings do
      if v == :never_defined
        parent_module.send(:remove_const, k)
      else
        parent_module.const_set(k, v)
      end
    end
  end
end

def set_test_const(const_name, value)
  const_name.is_a?(Symbol) and (const_name = const_name.to_s)
  const_name.is_a?(String) or raise "Pass the constant name, not its value!"

  final_parent_module = final_const_name = nil
  original_value      =
    const_name.split('::').reduce(Object) do |parent_module, nested_const_name|
      parent_module == :never_defined and raise "You need to set each parent constant earlier! #{nested_const_name}"
      final_parent_module = parent_module
      final_const_name    = nested_const_name
      begin
        parent_module.const_get(nested_const_name)
      rescue
        :never_defined
      end
    end

  @constant_overrides << [final_parent_module, final_const_name, original_value]

  silence_warnings { final_parent_module.const_set(final_const_name, value) }
end
