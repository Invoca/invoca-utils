# frozen_string_literal: true

class Module

  # Custom alias_method_chain that won't cause infinite recursion if called twice.
  # NOTE: Calling alias_method_chain on alias_method_chain was just way to confusing, so I copied it :-/
  def alias_method_chain(target, feature)
    # Strip out punctuation on predicates, bang or writer methods since
    # e.g. target?_without_feature is not a valid method name.
    aliased_target, punctuation = target.to_s.sub(/([?!=])$/, ''), $1 # rubocop:disable Style/PerlBackrefs
    yield(aliased_target, punctuation) if block_given?

    with_method = "#{aliased_target}_with_#{feature}#{punctuation}"
    without_method = "#{aliased_target}_without_#{feature}#{punctuation}"

    unless method_defined?(without_method)
      alias_method without_method, target
      alias_method target, with_method

      if public_method_defined?(without_method)
        public target
      elsif protected_method_defined?(without_method)
        protected target
      elsif private_method_defined?(without_method)
        private target
      end
    end
  end
end
