#
# Used by functional tests to track exceptions.
#

module LogErrorStub
  class UnexpectedExceptionLogged < StandardError; end
  class ExpectedExceptionNotLogged < StandardError; end

  def setup_log_error_stub
    clear_exception_whitelist
    stub_log_error unless respond_to?(:dont_stub_log_error) && dont_stub_log_error
  end

  def teardown_log_error_stub
    ExceptionHandling.stub_handler = nil
    return unless @exception_whitelist
    @exception_whitelist.each do |item|
      add_failure("log_error expected #{item[1][:expected]} times with pattern: '#{item[0].is_a?(Regexp) ? item[0].source : item[0]}' #{item[1][:count]} found #{item[1][:found]}") unless item[1][:expected] == item[1][:found]
    end
  end

  attr_accessor :exception_whitelist

  #
  # Call this function in your functional tests - usually first line after a "should" statement
  # once called, you can then call expects_exception
  # By stubbing log error, ExceptionHandling will keep a list of all expected exceptions and
  # gracefully note their occurrence.
  #
  def stub_log_error
    ExceptionHandling.stub_handler = self
  end

  #
  # Gets called by ExceptionHandling::log_error in test mode.
  # If you have called expects_exception then this function will simply note that an
  # instance of that exception has occurred - otherwise it will raise (which will
  # generally result in a 500 return code for your test request)
  #
  def handle_stub_log_error(exception_data, always_raise = false)
    raise_unexpected_exception(exception_data) if always_raise || !exception_filtered?(exception_data)
  end

  #
  # Did the calling code call expects_exception on this exception?
  #
  def exception_filtered?(exception_data)
    @exception_whitelist && @exception_whitelist.any? do |expectation|
      if expectation[0] === exception_data[:error]
        expectation[1][:found] += 1
        true
      end
    end
  end

  #
  # Call this from your test file to declare what exceptions you expect to raise.
  #
  def expects_exception(pattern, options = {})
    @exception_whitelist ||= []
    expected_count = options[:count] || 1
    options = {:expected => expected_count, :found => 0}
    if to_increment = @exception_whitelist.find {|ex| ex[0] == pattern}
      to_increment[1][:expected] += expected_count
    else
      @exception_whitelist << [pattern, options]
    end
  end

  def clear_exception_whitelist
    @exception_whitelist = nil
  end

  private

  def raise_unexpected_exception(exception_data)
    raise(UnexpectedExceptionLogged,
          exception_data[:error] + "\n" +
          "---original backtrace---\n" +
          exception_data[:backtrace].join("\n") + "\n" +
          "------")
  end

end
