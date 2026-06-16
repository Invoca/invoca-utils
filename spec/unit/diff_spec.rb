# frozen_string_literal: true

require_relative '../spec_helper'

describe Invoca::Utils::Diff do
  describe ".compare" do
    it "does nothing when identical" do
      expect(described_class.compare(['a', 'b'], ['a', 'b'])).to eq('')
    end

    it "detects additions" do
      expect(described_class.compare(['a', 'c'], ['a', 'b', 'c'])).to eq(
        "  a\n+ b\n  c\n"
      )
    end

    it "detects additions at the front" do
      expect(described_class.compare(['b', 'c'], ['a', 'b', 'c'])).to eq(
        "+ a\n  b\n  c\n"
      )
    end

    it "detects additions at the end" do
      expect(described_class.compare(['a', 'b'], ['a', 'b', 'c'])).to eq(
        "  a\n  b\n+ c\n"
      )
    end

    it "detects deletions" do
      expect(described_class.compare(['a', 'b', 'c'], ['a', 'c'])).to eq(
        "  a\n- b\n  c\n"
      )
    end

    it "detects deletions at the front" do
      expect(described_class.compare(['a', 'b', 'c'], ['b', 'c'])).to eq(
        "- a\n  b\n  c\n"
      )
    end

    it "detects deletions at the end" do
      expect(described_class.compare(['a', 'b', 'c'], ['a', 'b'])).to eq(
        "  a\n  b\n- c\n"
      )
    end

    it "detects changes" do
      expect(described_class.compare(['a', 'b1', 'c'], ['a', 'b2', 'c'])).to eq(
        "  a\n- b1\n+ b2\n  c\n"
      )
    end

    it "detects changes at the front" do
      expect(described_class.compare(['a1', 'b', 'c'], ['a2', 'b', 'c'])).to eq(
        "- a1\n+ a2\n  b\n  c\n"
      )
    end

    it "detects changes at the end" do
      expect(described_class.compare(['a', 'b', 'c1'], ['a', 'b', 'c2'])).to eq(
        "  a\n  b\n- c1\n+ c2\n"
      )
    end

    it "detects multi-line changes" do
      expect(described_class.compare(['a', 'b1', 'b2', 'd'], ['a', 'c', 'd'])).to eq(
        "  a\n- b1\n- b2\n+ c\n  d\n"
      )
    end

    it "detects multi-line changes at the front" do
      expect(described_class.compare(['a1', 'b1', 'd'], ['a2', 'b2', 'b3', 'd'])).to eq(
        "- a1\n- b1\n+ a2\n+ b2\n+ b3\n  d\n"
      )
    end

    it "detects multi-line changes at the end" do
      expect(described_class.compare(['a', 'b', 'd1'], ['a', 'b', 'd2', 'd3'])).to eq(
        "  a\n  b\n- d1\n+ d2\n+ d3\n"
      )
    end

    it "uses inspect on complex data types and includes nested diff" do
      expect(described_class.compare(['a', 'b', [1, 2]], ['a', 'b', [1, 2, 3], 'c'])).to eq(
        "  a\n  b\n- [1, 2]\nNested array diff:\n  1\n  2\n+ 3\n\n+ [1, 2, 3]\n+ c\n"
      )
    end

    it "includes nested diff on array of hashes" do
      output = described_class.compare(
        ['a', 'b', { a: 1, b: 2 }],
        ['a', 'b', { a: 1, b: 5, c: 3 }]
      )

      expect(output).to match(/\- \{.*\}/)
      expect(output).to include("Nested hash diff:")
      expect(output).to include("[:b] expected 2, was 5")
      expect(output).to include("[:c] not expected, was 3")
      expect(output).to match(/\+ \{.*\}/)
    end
  end
end
