# frozen_string_literal: true
require 'spec_helper'

describe PriceCalculator do
  let(:service) { PriceCalculator }

  describe '.calculate_for_sub_total' do
    it 'it calculates for 155' do
      value_object = service.calculate_for_sub_total(155)

      expect(value_object[:fees_paid_by_event]).to eq false
      expect(value_object[:sub_total]).to eq 155
      expect(value_object[:card_fee]).to eq 4.97
      expect(value_object[:application_fee]).to eq 1.21
      expect(value_object[:total_fee]).to eq 6.18
      expect(value_object[:total]).to eq 161.18
      expect(value_object[:buyer_pays]).to eq 161.18
      expect(value_object[:received_by_event]).to eq 155
    end

    it 'it calculates for 0' do
      value_object = service.calculate_for_sub_total(0)

      expect(value_object[:fees_paid_by_event]).to eq false
      expect(value_object[:sub_total]).to eq 0
      expect(value_object[:card_fee]).to eq 0
      expect(value_object[:application_fee]).to eq 0
      expect(value_object[:total_fee]).to eq 0
      expect(value_object[:total]).to eq 0
      expect(value_object[:buyer_pays]).to eq 0
      expect(value_object[:received_by_event]).to eq 0
    end

    it 'it calculates for 75 with fee absorbing' do
      value_object = service.calculate_for_sub_total(75, absorb_fees: true)

      expect(value_object[:fees_paid_by_event]).to eq true
      expect(value_object[:sub_total]).to eq 75
      expect(value_object[:card_fee]).to eq 2.48
      expect(value_object[:application_fee]).to eq 0.56
      expect(value_object[:total_fee]).to eq 3.04
      expect(value_object[:total]).to eq 75
      expect(value_object[:buyer_pays]).to eq 75
      expect(value_object[:received_by_event]).to eq 71.96
    end
  end
end
