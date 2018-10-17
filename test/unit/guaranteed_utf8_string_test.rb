# frozen_string_literal: true

require_relative '../test_helper'

class GuaranteedUTF8StringTest < Minitest::Test
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

  should "raise an error if initialized with an object with no to_s method" do
    assert_raises ArgumentError, /GuaranteedUTF8String must be initialized with a string or an object with a non-Kernel \.to_s method but instead was GuaranteedUTF8StringTest::HasNoTo_sMethod/ do
      Invoca::Utils::GuaranteedUTF8String.new(HasNoTo_sMethod.new)
    end
  end

  should "raise an error if initialized with a basic Ruby object" do
    assert_raises ArgumentError, /GuaranteedUTF8String must be initialized with a string or an object with a non-Kernel \.to_s method but instead was GuaranteedUTF8StringTest::BasicObjectWithKernelMethods/ do
      Invoca::Utils::GuaranteedUTF8String.new(BasicObjectWithKernelMethods.new)
    end
  end

  should "convert to a string with to_s if possible" do
    result = Invoca::Utils::GuaranteedUTF8String.new(ConvertibleToString.new("test string"))
    assert_equal "test string", result.to_string
  end

  context ".normalize_string" do
    should "not mutate the original string" do
      ascii_string = "new string".encode("ASCII")
      encoded_string = Invoca::Utils::GuaranteedUTF8String.normalize_string(ascii_string)

      assert_equal ascii_string, encoded_string
      assert_equal Encoding::ASCII, ascii_string.encoding
      assert_equal Encoding::UTF_8, encoded_string.encoding
    end

    should "return UTF-8 encoded string" do
      original_string = "this,is,a,valid,utf-8,csv,string\none,two,three,four,five,six,seven\n"

      encoded_string = Invoca::Utils::GuaranteedUTF8String.normalize_string(original_string)

      assert_equal original_string, encoded_string
      assert_equal Encoding::UTF_8, encoded_string.encoding
    end

    should "return UTF-8 encoded string without BOM" do
      original_string = "\xEF\xBB\xBFthis,is,a,valid,utf-8,csv,string\none,two,three,four,five,six,seven\n"

      encoded_string = Invoca::Utils::GuaranteedUTF8String.normalize_string(original_string)

      assert_equal "this,is,a,valid,utf-8,csv,string\none,two,three,four,five,six,seven\n", encoded_string
      assert_equal Encoding::UTF_8, encoded_string.encoding
    end

    should "return UTF-8 encoded string using to_s alias" do
      original_string = "this,is,a,valid,utf-8,csv,string\none,two,three,four,five,six,seven\n"

      encoded_string = Invoca::Utils::GuaranteedUTF8String.normalize_string(original_string)

      assert_equal original_string, encoded_string
      assert_equal Encoding::UTF_8, encoded_string.encoding
    end

    should "return UTF-8 encoded string after falling back to CP1252 encoding" do
      string = "This,is,NOT,a,valid,utf-8,csv,string\r\none,two,three,four,\x81five\xF6,six,seven,eight\n"
      expected_string = "This,is,NOT,a,valid,utf-8,csv,string\none,two,three,four,~fiveö,six,seven,eight\n"

      encoded_string = Invoca::Utils::GuaranteedUTF8String.normalize_string(string)

      assert_equal expected_string, encoded_string
      assert_equal Encoding::UTF_8, encoded_string.encoding
    end

    should "return UTF-8 encoded string with normalized return chars" do
      string          = "This string\n\n\n has line feeds\ncarriage\r\r returns\rand Windows\r\n\r\n new line chars\r\nend of \n\r\r\r\nstring"
      expected_string = "This string\n\n\n has line feeds\ncarriage\n\n returns\nand Windows\n\n new line chars\nend of \n\n\n\nstring"

      encoded_string = Invoca::Utils::GuaranteedUTF8String.normalize_string(string)

      assert_equal expected_string, encoded_string
      assert_equal Encoding::UTF_8, encoded_string.encoding
    end

    should "encode all 255 UTF-8 characters, returning ~ when the character isn't mapped in CP1252" do
      all_8_bit_characters = (1..255).map { |char| char.chr }.join

      final_utf_8_string = Invoca::Utils::GuaranteedUTF8String.normalize_string(all_8_bit_characters)
      expected_string = "\u0001\u0002\u0003\u0004\u0005\u0006\u0007\u0008\u0009\u000A\u000B\u000C\u000A\u000E\u000F\u0010\u0011\u0012\u0013\u0014\u0015\u0016\u0017\u0018\u0019\u001A\u001B\u001C\u001D\u001E\u001F !\"\#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~\u007F€~‚ƒ„…†‡ˆ‰Š‹Œ~Ž~~‘’“”•–—˜™š›œ~žŸ ¡¢£¤¥¦§¨©ª«¬­®¯°±²³´µ¶·¸¹º»¼½¾¿ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖ×ØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõö÷øùúûüýþÿ"

      assert_equal expected_string, final_utf_8_string
    end

    should "consider UTF-8 code points that take > 3 bytes (above U+FFFF) to be invalid (since MySQL can't store them unless column is declared mb4) and encode them as ~" do
      string          = "This string has some ✓ valid UTF-8 but also some 😹 emoji \xf0\x9f\x98\xb9 that are > U+FFFF"
      expected_string = "This string has some ✓ valid UTF-8 but also some ~ emoji ~ that are > U+FFFF"

      encoded_string = Invoca::Utils::GuaranteedUTF8String.normalize_string(string)

      assert_equal expected_string, encoded_string
      assert_equal Encoding::UTF_8, encoded_string.encoding
    end
  end

  context "constructor" do
    should "call normalize_string with the default conversions" do
      mock(Invoca::Utils::GuaranteedUTF8String).normalize_string("")

      Invoca::Utils::GuaranteedUTF8String.new("").to_string
    end
  end
end

