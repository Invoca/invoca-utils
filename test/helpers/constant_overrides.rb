# frozen_string_literal: true

# The same as https://github.com/Invoca/test_overrides/blob/master/lib/constant_overrides.rb,
# but less coupled to ExceptionHandling and Invoca microservices.

module ConstantOverrides
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
end
