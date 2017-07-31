# frozen_string_literal: true
require 'spec_helper'

describe CollaboratorsMailer do
  context 'invitation' do
    it 'creates an email' do
      user = create(:user)
      event = create(:event)

      expect {
        CollaboratorsMailer.invitation(
          from: user, email_to: 'a@a.o',
          host: event, link: '/'
        ).deliver_now!
      }.to change(ActionMailer::Base.deliveries, :count).by 1
    end
  end
end
