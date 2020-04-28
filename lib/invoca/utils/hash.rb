# frozen_string_literal: true

# Invoca ::Hash extensions
class Hash

  def select_hash(&block)
    res = {}
    each { |k, v| res[k] = v if (block.arity == 1 ? yield(v) : yield(k, v)) } # rubocop:disable Style/ParenthesesAroundCondition
    res
  end

  def map_hash(&block)
    res = {}
    each { |k, v| res[k] = block.arity == 1 ? yield(v) : yield(k, v) }
    res
  end

  def partition_hash(keys = nil)
    yes = {}
    no = {}
    each do |k, v|
      if block_given? ? yield(k, v) : keys.include?(k)
        yes[k] = v
      else
        no[k] = v
      end
    end
    [yes, no]
  end

  # rubocop:disable Naming/BinaryOperatorParameterName
  def -(keys)
    res = {}
    each_pair { |k, v| res[k] = v unless k.in?(keys) }
    res
  end

  def &(keys)
    res = {}
    keys.each { |k| res[k] = self[k] if has_key?(k) }
    res
  end
  # rubocop:enable Naming/BinaryOperatorParameterName
end
