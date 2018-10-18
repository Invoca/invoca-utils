# frozen_string_literal: true

# This class expects to be provides a normalize_string method that guarantees that the output of the to_string method is in UTF-8
# format and fits in 3 bytes/char or less.
#
# [Deprecated] Equivalently, you can also create an instance of this class and call to_string or to_s on it.
module Invoca
  module Utils
    class GuaranteedUTF8String
      attr_reader :to_string

      def initialize(string)
        @to_string = self.class.normalize_string(string)
      end

      alias to_s to_string

      private

      # chosen because this is a 1-byte ASCII character that is not used in any of the popular escaping systems: XML, HTML, HTTP URIs, HTTP Form Post, JSON
      REPLACE_CHARACTER = '~'

      class << self
        def normalize_string(orig_string, normalize_utf16: true,
                             normalize_cp1252:             true,
                             normalize_newlines:           true,
                             remove_utf8_bom:              true,
                             replace_unicode_beyond_ffff:  true)
          string =  if orig_string.is_a?(String) ||
                      (orig_string.respond_to?(:to_s) &&
                        orig_string.method(:to_s).owner != Kernel) # the lame .to_s from Kernel just calls .inspect :(
                      orig_string.to_s.dup
                    else
                      raise ArgumentError, "must be passed a string or an object with a non-Kernel .to_s method but instead was #{orig_string.class} #{orig_string.inspect}"
                    end
          string.force_encoding('UTF-8')
          normalize_utf_16(string)             if normalize_utf16
          unless string.valid_encoding?
            if normalize_cp1252
              cp1252_to_utf_8(string)
            else
              raise ArgumentError, 'Could not normalize to utf8 due to invalid characters (possibly CP1252)'
            end
          end
          normalize_newlines(string)           if normalize_newlines
          remove_utf8_bom(string)              if remove_utf8_bom
          replace_unicode_beyond_ffff(string)  if replace_unicode_beyond_ffff
          string
        end

        private

        UTF_16_LE_BOM = "\xFF\xFE"
        UTF_16_BE_BOM = "\xFE\xFF"

        PRIVATE_CP1252_CHAR_PATTERN = "[\u0080-\u009f]"
        PRIVATE_CP1252_CHAR_PATTERN_UTF_16LE = Regexp.new(PRIVATE_CP1252_CHAR_PATTERN.encode('UTF-16LE'))
        PRIVATE_CP1252_CHAR_PATTERN_UTF_16BE = Regexp.new(PRIVATE_CP1252_CHAR_PATTERN.encode('UTF-16BE'))

        def normalize_utf_16(string)
          case string[0, 2]
          when UTF_16_LE_BOM
            string.slice!(0, 2)                 # remove the BOM
            string.force_encoding('UTF-16LE')
            normalize_multibyte_cp1252(string, PRIVATE_CP1252_CHAR_PATTERN_UTF_16LE, 'UTF-16LE')
            string.encode!('UTF-8')
          when UTF_16_BE_BOM
            string.slice!(0, 2)                 # remove the BOM
            string.force_encoding('UTF-16BE')
            normalize_multibyte_cp1252(string, PRIVATE_CP1252_CHAR_PATTERN_UTF_16BE, 'UTF-16BE')
            string.encode!('UTF-8')
          end
        end

        def normalize_multibyte_cp1252(string, pattern, encoding)
          string.gsub!(pattern) { |c| c.ord.chr.force_encoding('CP1252').encode('UTF-8').encode(encoding) }
        end

        def normalize_newlines(string)
          string.gsub!(/ \r\n | \r | \n /x, "\n")
        end

        def cp1252_to_utf_8(string)
          string.force_encoding('CP1252')
          string.encode!(
            'UTF-8',
            replace:  REPLACE_CHARACTER,
            undef:    :replace,
            invalid:  :replace
          )
        end

        def remove_utf8_bom(string)
          string.sub!(/\A \xEF\xBB\xBF/x, '')
        end

        # Note MySQL can only store Unicode up to code point U+FFFF in the standard mb3 storage type. There is an option to use mb4 which
        # is needed to hold the code points above that (including emoji) but we haven't enabled that on any columns yet since
        # it would take a data migration and didn't seem that important.

        def replace_unicode_beyond_ffff(string)
          string.gsub!(/[^\u{0}-\u{ffff}]/x, REPLACE_CHARACTER)
        end
      end
    end
  end
end
