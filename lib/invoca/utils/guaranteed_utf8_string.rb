# frozen_string_literal: true

# This class expects to be initialized with a string and guarantees that the output of the to_string method is in UTF-8 format and fits in 3 bytes/char or less.
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
        def normalize_string(orig_string, normalize_cp1252: true, normalize_newlines: true, remove_utf8_bom: true, replace_unicode_beyond_ffff: true)
          string =  if orig_string.is_a?(String) ||
                      (orig_string.respond_to?(:to_s) &&
                        orig_string.method(:to_s).owner != Kernel) # the lame .to_s from Kernel just calls .inspect :(
                      orig_string.to_s.dup
                    else
                      raise ArgumentError, "must be passed a string or an object with a non-Kernel .to_s method but instead was #{orig_string.class} #{orig_string.inspect}"
                    end
          string.force_encoding('UTF-8')
          unless string.valid_encoding?
            if normalize_cp1252
              cp1252_to_utf_8(string)
            else
              raise ArgumentError, "Could not normalize to utf8 due to invalid characters (possibly CP1252)"
            end
          end
          normalize_newlines(string)           if normalize_newlines
          remove_utf8_bom(string)              if remove_utf8_bom
          replace_unicode_beyond_ffff(string)  if replace_unicode_beyond_ffff
          string
        end

        private

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
