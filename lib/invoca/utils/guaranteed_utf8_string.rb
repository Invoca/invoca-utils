# frozen_string_literal: true

# This class expects to be initialized with a string and guarantees that the output of the to_string method is in UTF-8 format and fits in 3 bytes/char or less.
module Invoca
  module Utils
    class GuaranteedUTF8String
      def initialize(string)
        if string.is_a?(String) ||
           (string.respond_to?(:to_s) &&
            string.method(:to_s).owner != Kernel) # the lame .to_s from Kernel just calls .inspect :(
          @string = string.to_s
        else
          raise ArgumentError, "#{self.class} must be initialized with a string or an object with a non-Kernel .to_s method but instead was #{string.class} #{string.inspect}"
        end
      end

      def to_string
        @to_string ||= self.class.normalize_string(@string)
      end

      alias to_s to_string

      private

      # chosen because this is a 1-byte ASCII character that is not used in any of the popular escaping systems: XML, HTML, HTTP URIs, HTTP Form Post, JSON
      REPLACE_CHARACTER = '~'

      class << self
        def normalize_string(orig_str, normalize_cp1252: true, normalize_newlines: true, remove_utf8_bom: true, replace_unicode_beyond_ffff: true)
          str = orig_str.dup
          str.force_encoding('UTF-8')
          unless str.valid_encoding?
            if normalize_cp1252
              cp1252_to_utf_8(str)
            else
              raise ArgumentError, "Could not normalize to utf8 due to invalid characters (possibly CP1252)"
            end
          end
          normalize_newlines(str) if normalize_newlines
          remove_utf8_bom(str) if remove_utf8_bom
          replace_unicode_beyond_ffff(str) if replace_unicode_beyond_ffff
          str
        end

        private

        def normalize_newlines(str)
          str.gsub!(/ \r\n | \r | \n /x, "\n")
        end

        def cp1252_to_utf_8(str)
          str.force_encoding('CP1252')
          str.encode!(
            'UTF-8',
            replace:  REPLACE_CHARACTER,
            undef:    :replace,
            invalid:  :replace
          )
        end

        def remove_utf8_bom(str)
          str.sub!(/\A \xEF\xBB\xBF/x, '')
        end

        # Note MySQL can only store Unicode up to code point U+FFFF in the standard mb3 storage type. There is an option to use mb4 which
        # is needed to hold the code points above that (including emoji) but we haven't enabled that on any columns yet since
        # it would take a data migration and didn't seem that important.

        def replace_unicode_beyond_ffff(str)
          str.gsub!(/[^\u{0}-\u{ffff}]/x, REPLACE_CHARACTER)
        end
      end
    end
  end
end
