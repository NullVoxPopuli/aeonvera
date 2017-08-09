# frozen_string_literal: true

require 'spec_helper'

describe Duration do
  context '#duration' do
    before(:each) do
      @membership_option = build(:membership_option)
      @durationable = build(:membership_renewal, membership_option: @membership_option)
      @membership_option.duration_amount = 1
    end

    it 'is a day' do
      @membership_option.duration_unit = Duration::DURATION_DAY
      expect(@durationable.duration).to eq 1.day
    end

    it 'is a week' do
      @membership_option.duration_unit = Duration::DURATION_WEEK
      expect(@durationable.duration).to eq 1.week
    end

    it 'is a month' do
      @membership_option.duration_unit = Duration::DURATION_MONTH
      expect(@durationable.duration).to eq 1.month
    end

    it 'is a year' do
      @membership_option.duration_unit = Duration::DURATION_YEAR
      expect(@durationable.duration).to eq 1.year
    end
  end
end
