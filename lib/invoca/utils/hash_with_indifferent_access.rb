# frozen_string_literal: true

# Invoca ::HashWithIndifferentAccess extensions
if defined? HashWithIndifferentAccess

  class HashWithIndifferentAccess

    # rubocop:disable Naming/BinaryOperatorParameterName
    def -(keys)
      res = HashWithIndifferentAccess.new
      keys = keys.map { |k| k.is_a?(Symbol) ? k.to_s : k }
      each_pair { |k, v| res[k] = v unless k.in?(keys) }
      res
    end

    def &(keys)
      res = HashWithIndifferentAccess.new
      keys.each do |k|
        k = k.to_s if k.is_a?(Symbol)
        res[k] = self[k] if has_key?(k)
      end
      res
    end
    # rubocop:enable Naming/BinaryOperatorParameterName

    def partition_hash(keys = nil)
      keys = keys&.map { |k| k.is_a?(Symbol) ? k.to_s : k }
      yes = HashWithIndifferentAccess.new
      no = HashWithIndifferentAccess.new
      each do |k, v|
        if block_given? ? yield(k, v) : keys.include?(k)
          yes[k] = v
        else
          no[k] = v
        end
      end
      [yes, no]
    end

  end

end
