# frozen_string_literal: true

module Invoca
  module Utils
    class << self
      def retry_on_exception(exception_classes, retries:, before_retry: nil)
        retries.times do |attempt_number|
          begin
            return yield(attempt_number)
          rescue *Array(exception_classes) => ex
            before_retry&.call(ex)
          end
        end

        yield(retries)   # no rescue for this last time, so any exceptions will raise out
      end
    end
  end
end
