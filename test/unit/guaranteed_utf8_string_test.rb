# frozen_string_literal: true

require_relative '../../lib/invoca/utils/guaranteed_utf8_string'
require_relative '../test_helper'

describe Invoca::Utils::GuaranteedUTF8String do
  class HasNoTo_sMethod
    undef :to_s
  end

  class BasicObjectWithKernelMethods
  end

  class ConvertibleToString
    attr_reader :to_s

    def initialize(string)
      @to_s = string
    end
  end

  context '.normalize_string' do
    it 'raise an error if called with an object with no to_s method' do
      expect do
        Invoca::Utils::GuaranteedUTF8String.normalize_string(HasNoTo_sMethod.new)
      end.to raise_exception(ArgumentError, /must be passed a string or an object with a non-Kernel \.to_s method but instead was HasNoTo_sMethod/)
    end

    it 'raise an error if called with a basic Ruby object' do
      expect do
        Invoca::Utils::GuaranteedUTF8String.normalize_string(BasicObjectWithKernelMethods.new)
      end.to raise_exception(ArgumentError,
                             /must be passed a string or an object with a non-Kernel \.to_s method but instead was BasicObjectWithKernelMethods/)
    end

    it 'not mutate the original string' do
      ascii_string = 'new string'.encode('ASCII')
      encoded_string = Invoca::Utils::GuaranteedUTF8String.normalize_string(ascii_string)

      expect(encoded_string).to eq(ascii_string)
      expect(ascii_string.encoding).to eq(Encoding::ASCII)
      expect(encoded_string.encoding).to eq(Encoding::UTF_8)
    end

    it 'return UTF-8 encoded string' do
      original_string = "this,is,a,valid,utf-8,csv,string\none,two,three,four,five,six,seven\n"

      encoded_string = Invoca::Utils::GuaranteedUTF8String.normalize_string(original_string)

      expect(encoded_string).to eq(original_string)
      expect(encoded_string.encoding).to eq(Encoding::UTF_8)
    end

    context "normalize_utf16" do
      UTF16_LE_BOM = "\xFF\xFE"
      UTF16_BE_BOM = "\xFE\xFF"
      UTF16_LE_TEST_STRING = (UTF16_LE_BOM + "v\x00a\x00l\x00i\x00d\x00,\x00u\x00t\x00f\x00-\x001\x006\x00\n\x00s\x00e\x00c\x00o\x00n\x00d\x00").force_encoding('BINARY').freeze
      UTF16_BE_TEST_STRING = (UTF16_BE_BOM + "\x00v\x00a\x00l\x00i\x00d\x00,\x00u\x00t\x00f\x00-\x001\x006\x00\n\x00s\x00e\x00c\x00o\x00n\x00d").force_encoding('BINARY').freeze

      it 'accept UTF-16LE in BINARY and return UTF-8 encoded string when true' do
        encoded_string = Invoca::Utils::GuaranteedUTF8String.normalize_string(UTF16_LE_TEST_STRING, normalize_utf16: true)

        expect(encoded_string).to eq("valid,utf-16\nsecond")
        expect(encoded_string.encoding).to eq(Encoding::UTF_8)
      end

      it 'not check for UTF-16LE in BINARY and return UTF-8 encoded string when false' do
        encoded_string = Invoca::Utils::GuaranteedUTF8String.normalize_string(UTF16_LE_TEST_STRING, normalize_utf16: false)
        expected = "ÿþv\u0000a\u0000l\u0000i\u0000d\u0000,\u0000u\u0000t\u0000f\u0000-\u00001\u00006\u0000\n\u0000s\u0000e\u0000c\u0000o\u0000n\u0000d\u0000"

        expect(encoded_string).to eq(expected)
        expect(encoded_string.encoding).to eq(Encoding::UTF_8)
      end

      it 'accept UTF-16BE in BINARY and return UTF-8 encoded string when true' do
        encoded_string = Invoca::Utils::GuaranteedUTF8String.normalize_string(UTF16_BE_TEST_STRING, normalize_utf16: true)

        expect(encoded_string).to eq("valid,utf-16\nsecond")
        expect(encoded_string.encoding).to eq(Encoding::UTF_8)
      end

      it 'not check for UTF-16BE in BINARY and return UTF-8 encoded string when false' do
        encoded_string = Invoca::Utils::GuaranteedUTF8String.normalize_string(UTF16_BE_TEST_STRING, normalize_utf16: false)
        expected = "þÿ\u0000v\u0000a\u0000l\u0000i\u0000d\u0000,\u0000u\u0000t\u0000f\u0000-\u00001\u00006\u0000\n\u0000s\u0000e\u0000c\u0000o\u0000n\u0000d"

        expect(encoded_string).to eq(expected)
        expect(encoded_string.encoding).to eq(Encoding::UTF_8)
      end

      context "containing embedded CP1252" do
        it 'accept UTF-16LE in BINARY and return UTF-8 encoded string with "private" CP1252 when normalize_utf16: true, normalize_cp1252: false' do
          original_string = (UTF16_LE_BOM + "\x91\x00s\x00m\x00a\x00r\x00t\x00 \x00q\x00u\x00o\x00t\x00e\x00s\x00\x92\x00\n\x00s\x00e\x00c\x00o\x00n\x00d\x00").force_encoding('BINARY')

          encoded_string = Invoca::Utils::GuaranteedUTF8String.normalize_string(original_string, normalize_utf16: true, normalize_cp1252: false)

          expect(encoded_string).to eq("\u0091smart quotes\u0092\nsecond")
          expect(encoded_string.encoding).to eq(Encoding::UTF_8)
        end

        it 'accept UTF-16LE in BINARY and return UTF-8 encoded string with normalized CP1252 when normalize_utf16: true, normalize_cp1252: true' do
          original_string = (UTF16_LE_BOM + "\x91\x00s\x00m\x00a\x00r\x00t\x00 \x00q\x00u\x00o\x00t\x00e\x00s\x00\x92\x00\n\x00s\x00e\x00c\x00o\x00n\x00d\x00").force_encoding('BINARY')

          encoded_string = Invoca::Utils::GuaranteedUTF8String.normalize_string(original_string, normalize_utf16: true)

          expect(encoded_string).to eq("‘smart quotes’\nsecond")
          expect(encoded_string.encoding).to eq(Encoding::UTF_8)
        end

        it 'accept UTF-16BE in BINARY and return UTF-8 encoded string when normalize_utf16: true, normalize_cp1252: false' do
          original_string = (UTF16_BE_BOM + "\x00\x91\x00s\x00m\x00a\x00r\x00t\x00 \x00q\x00u\x00o\x00t\x00e\x00s\x00\x92\x00\n\x00s\x00e\x00c\x00o\x00n\x00d").force_encoding('BINARY')

          encoded_string = Invoca::Utils::GuaranteedUTF8String.normalize_string(original_string, normalize_utf16: true, normalize_cp1252: false)

          expect(encoded_string).to eq("\u0091smart quotes\u0092\nsecond")
          expect(encoded_string.encoding).to eq(Encoding::UTF_8)
        end

        it 'accept UTF-16BE in BINARY and return UTF-8 encoded string when normalize_utf16: true, normalize_cp1252: true' do
          original_string = (UTF16_BE_BOM + "\x00\x91\x00s\x00m\x00a\x00r\x00t\x00 \x00q\x00u\x00o\x00t\x00e\x00s\x00\x92\x00\n\x00s\x00e\x00c\x00o\x00n\x00d").force_encoding('BINARY')

          encoded_string = Invoca::Utils::GuaranteedUTF8String.normalize_string(original_string, normalize_utf16: true, normalize_cp1252: true)

          expect(encoded_string).to eq("‘smart quotes’\nsecond")
          expect(encoded_string.encoding).to eq(Encoding::UTF_8)
        end
      end
    end

    context 'normalize_cp1252' do
      before do
        @string = "This,is,NOT,a,valid,utf-8,csv,string\r\none,two,three,four,\x81five,\x91smart quotes\x92,\x93suck!\x94\n"
      end

      it 'raise ArgumentError when false' do
        expect do
          Invoca::Utils::GuaranteedUTF8String.normalize_string(@string, normalize_cp1252: false)
        end.to raise_exception(ArgumentError)
      end

      it 'return UTF-8 encoded string after falling back to CP1252 encoding when true' do
        expected_string = "This,is,NOT,a,valid,utf-8,csv,string\none,two,three,four,~five,‘smart quotes’,“suck!”\n"

        encoded_string = Invoca::Utils::GuaranteedUTF8String.normalize_string(@string)

        expect(encoded_string).to eq(expected_string)
        expect(encoded_string.encoding).to eq(Encoding::UTF_8)
      end

      it "encode all 255 UTF-8 characters, returning ~ when the character isn't mapped in CP1252" do
        all_8_bit_characters = (1..255).map(&:chr).join

        final_utf_8_string = Invoca::Utils::GuaranteedUTF8String.normalize_string(all_8_bit_characters)
        expected_string = "\u0001\u0002\u0003\u0004\u0005\u0006\u0007\u0008\u0009\u000A\u000B\u000C\u000A\u000E\u000F\u0010\u0011\u0012\u0013\u0014\u0015\u0016\u0017\u0018\u0019\u001A\u001B\u001C\u001D\u001E\u001F !\"\#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~\u007F€~‚ƒ„…†‡ˆ‰Š‹Œ~Ž~~‘’“”•–—˜™š›œ~žŸ ¡¢£¤¥¦§¨©ª«¬­®¯°±²³´µ¶·¸¹º»¼½¾¿ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖ×ØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõö÷øùúûüýþÿ"

        expect(final_utf_8_string).to eq(expected_string)
      end
    end

    context 'normalize_newlines' do
      before do
        @string = "This string\n\n\n has line feeds\ncarriage\r\r returns\rand Windows\r\n\r\n new line chars\r\nend of \n\r\r\r\nstring"
      end

      it 'return UTF-8 encoded string without normalized return chars when false' do
        encoded_string = Invoca::Utils::GuaranteedUTF8String.normalize_string(@string, normalize_newlines: false)

        expect(encoded_string).to eq(@string)
        expect(encoded_string.encoding).to eq(Encoding::UTF_8)
      end

      it 'return UTF-8 encoded string with normalized return chars when true' do
        expected_string = "This string\n\n\n has line feeds\ncarriage\n\n returns\nand Windows\n\n new line chars\nend of \n\n\n\nstring"

        encoded_string = Invoca::Utils::GuaranteedUTF8String.normalize_string(@string, normalize_newlines: true)

        expect(encoded_string).to eq(expected_string)
        expect(encoded_string.encoding).to eq(Encoding::UTF_8)
      end
    end

    context 'remove_utf8_bom' do
      before do
        @original_string = "\xEF\xBB\xBFthis,is,a,valid,utf-8,csv,string\none,two,three,four,five,six,seven\n"
      end

      it 'return UTF-8 encoded string with BOM intact when false' do
        encoded_string = Invoca::Utils::GuaranteedUTF8String.normalize_string(@original_string, remove_utf8_bom: false)

        expect(encoded_string).to eq("\xEF\xBB\xBFthis,is,a,valid,utf-8,csv,string\none,two,three,four,five,six,seven\n")
        expect(encoded_string.encoding).to eq(Encoding::UTF_8)
      end

      it 'return UTF-8 encoded string without BOM when true' do
        encoded_string = Invoca::Utils::GuaranteedUTF8String.normalize_string(@original_string, remove_utf8_bom: true)

        expect(encoded_string).to eq("this,is,a,valid,utf-8,csv,string\none,two,three,four,five,six,seven\n")
        expect(encoded_string.encoding).to eq(Encoding::UTF_8)
      end
    end

    context 'replace_unicode_beyond_ffff' do
      before do
        @string = "This string has some ✓ valid UTF-8 but also some 😹 emoji \xf0\x9f\x98\xb9 that are > U+FFFF"
      end

      it "consider UTF-8 code points that take > 3 bytes (above U+FFFF) to be invalid (since MySQL can't store them unless column is declared mb4) and encode them as ~ when false" do
        encoded_string = Invoca::Utils::GuaranteedUTF8String.normalize_string(@string, replace_unicode_beyond_ffff: false)

        expect(encoded_string).to eq(@string)
        expect(encoded_string.encoding).to eq(Encoding::UTF_8)
      end

      it "consider UTF-8 code points that take > 3 bytes (above U+FFFF) to be invalid (since MySQL can't store them unless column is declared mb4) and encode them as ~ when true" do
        expected_string = 'This string has some ✓ valid UTF-8 but also some ~ emoji ~ that are > U+FFFF'

        encoded_string = Invoca::Utils::GuaranteedUTF8String.normalize_string(@string, replace_unicode_beyond_ffff: true)

        expect(encoded_string).to eq(expected_string)
        expect(encoded_string.encoding).to eq(Encoding::UTF_8)
      end
    end

    context ".normalize_strings" do
      it "walk json doc, replacing strings in: values, inside array elements, and hash keys and values" do
        json_doc = {
          '😹' => "\xE2\x9C\x93 laughing cat",
          ['😹'] => ["\xE2", "\xf0\x9f\x98\xb9", { "newline" => "\r\n" }],
          'cp1252' => "\x91smart quotes\x92"
        }

        normalized_json = Invoca::Utils::GuaranteedUTF8String.normalize_all_strings(json_doc,
                                                                                    normalize_utf16:              true,
                                                                                    normalize_cp1252:             true,
                                                                                    normalize_newlines:           true,
                                                                                    remove_utf8_bom:              true,
                                                                                    replace_unicode_beyond_ffff:  true)

        expect({
                       '~' => "✓ laughing cat",
                       ['~'] => ["â", "~", { "newline" => "\n" }],
                       'cp1252' => "‘smart quotes’"
                     }).to eq(normalized_json)
      end
    end
  end

  context 'constructor' do
    it 'call normalize_string with the default conversions' do
      expect(Invoca::Utils::GuaranteedUTF8String).to receive(:normalize_string).with('')

      Invoca::Utils::GuaranteedUTF8String.new('').to_string
    end

    it 'do the same when using to_s alias' do
      expect(Invoca::Utils::GuaranteedUTF8String).to receive(:normalize_string).with('')

      Invoca::Utils::GuaranteedUTF8String.new('').to_s
    end
  end
end
