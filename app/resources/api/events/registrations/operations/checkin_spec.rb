# frozen_string_literal: true

require 'spec_helper'

describe Api::Events::RegistrationOperations::Checkin do
  context 'a registration has yet to be checked in' do
    let(:user) { create_confirmed_user }
    let(:event) { create(:event) }
    let!(:collaboration) { create(:collaboration, user: user, collaborated: event) }
    let!(:registration) { create(:registration, host: event) }
    let(:params) {
      { id: registration.id, event_id: event.id, checked_in_at: Time.now }
    }

    subject { described_class.new(user, params) }

    it 'changes the number of checked in registrations' do
      expect { subject.run }
        .to change(Registration.checkedin, :count).by(1)
    end

    it 'sets checked_in_at' do
      subject.run

      registration.reload
      expect(registration.checked_in_at).to_not eq nil
    end
  end
end
