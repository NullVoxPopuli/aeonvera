# frozen_string_literal: true

require 'spec_helper'

describe Api::Events::RegistrationOperations::Transfer do
  context 'transferring to another person' do
    let(:event) { create(:event) }
    let!(:registration) { create(:registration, host: event) }
    let(:params) {
      {
        id: registration.id, event_id: event.id,
        transferred_to_email: 'luke@skywalker.jedi',
        transferred_to_first_name: 'Luke',
        transferred_to_last_name: 'Skywalker',
        transfer_reason: 'Death in the family'
      }
    }

    subject { described_class.new(event.user, params, params) }

    it 'sets the transferred at' do
      expect(subject.run.transferred_at).to_not be_nil
    end

    it 'updates the attendee_name' do
      registration = subject.run

      expect(registration.attendee_name).to eq 'Luke Skywalker'
      expect(registration.attendee_first_name).to eq 'Luke'
      expect(registration.attendee_last_name).to eq 'Skywalker'
    end

    it 'does not set the year' do
      registration = subject.run

      expect(registration.transferred_to_year).to eq nil
    end

    it 'sets the reason' do
      registration = subject.run

      expect(registration.transfer_reason).to eq 'Death in the family'
    end

    xit 'sends an email to the transferred_to_email with a link to confirm' do
      pending('implement this')
    end
  end

  context 'transferring to a year' do
    let(:event) { create(:event) }
    let!(:registration) { create(:registration, host: event) }
    let(:params) {
      {
        id: registration.id, event_id: event.id,
        transferred_to_year: '3043',
        transfer_reason: 'Death in the family'
      }
    }

    subject { described_class.new(event.user, params) }

    it 'sets the year' do
      registration = subject.run

      expect(registration.transferred_to_year.to_i).to eq 3043
    end

    it 'sets the reason' do
      updated = subject.run
      expect(updated.transfer_reason).to eq 'Death in the family'
    end

    it 'does not change the name' do
      updated = subject.run

      expect(updated.attendee_name).to eq(registration.attendee_name)
    end
  end
end
