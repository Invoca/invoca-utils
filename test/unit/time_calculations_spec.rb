# frozen_string_literal: true

require_relative '../spec_helper'

describe Time do
  context "beginning_of_hour" do
    Time.zone = 'Pacific Time (US & Canada)'
    [
      Time.now,
      Time.zone.now,
      Time.local(2009),
      Time.local(2009,3,4,5),
      Time.local(2001,12,31,23,59),
      Time.local(1970,1,1)
    ].each_with_index do |time, index|
      it "give back a time with no minutes, seconds, or msec: #{time} (#{index})" do
        t = time.beginning_of_hour
        expect(time.year).to eq(t.year)
        expect(time.month).to eq(t.month)
        expect(time.day).to eq(t.day)
        expect(time.hour).to eq(t.hour)
        expect(t.min).to eq(0)
        expect(t.sec).to eq(0)
        expect(t.usec).to eq(0)
      end
    end
  end

  context "end_of_day_whole_sec" do
    it "return the end of day with whole_sec" do
      t = Time.now
      end_of_day = t.end_of_day
      end_whole_sec = t.end_of_day_whole_sec
      expect(end_whole_sec.usec).to eq(0.0)
      expect(end_whole_sec.to_i).to eq(end_of_day.to_i)
      expect(end_whole_sec.sec).to eq(end_of_day.sec)
    end
  end
end
