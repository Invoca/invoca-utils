# frozen_string_literal: true

module Invoca
  module Utils
    class << self
      # Yields and rescues any exceptions given in `exception_classes`, retrying the given number of times.
      # The final retry does not rescue any exceptions.
      # The try number (0..retries) is yielded as a block param.
      #
      # @param [Class or Array(Class)] exception_classes - exception()s) to rescue
      # @param [Integer] retries: - 1+ count of retries (1 retry = up to 2 tries total)
      # @param [Proc] before_retry - optional proc which is called before each retry, with the exception passed as a block param
      # @return the value from yield
      def retry_on_exception(exception_classes, retries: 1, before_retry: nil)
        retries.times do |attempt_number|
          begin
            return yield(attempt_number)
          rescue *Array(exception_classes) => ex
            before_retry&.call(ex)
          end
        end

        yield(retries)   # no rescue for this last try, so any exceptions will raise out
      end
    end
  end
end
