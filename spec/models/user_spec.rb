# frozen_string_literal: true
# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  first_name             :string(255)
#  last_name              :string(255)
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string(255)
#  failed_attempts        :integer          default(0)
#  unlock_token           :string(255)
#  locked_at              :datetime
#  created_at             :datetime
#  updated_at             :datetime
#  deleted_at             :datetime
#  time_zone              :string(255)
#  authentication_token   :string
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#

require 'spec_helper'

describe User do
  describe '#owned_and_collaborated_organizations' do
    it 'owns an organization' do
      org = create(:organization, owner: create_confirmed_user)
      user = org.owner
      orgs = user.owned_and_collaborated_organizations

      expect(orgs).to include(org)
    end

    it 'collaborates on an organization' do
      org = create(:organization, owner: create_confirmed_user)
      user = create_confirmed_user
      org.collaborators << user
      org.save

      orgs = user.owned_and_collaborated_organizations

      expect(orgs).to include(org)
    end
  end

  context 'events' do
    let(:user) { create(:user) }

    before(:each) do
      @event = create(:event)
    end

    describe '#not_attending_event?' do
      it 'prevents deleting' do
        user.stub(:upcoming_events).and_return([@event])
        user.destroy
        expect(user.deleted?).to eq false
        expect(user.deleted_at).to eq nil
        expect(user.errors.full_messages.size).to eq 1
        expect(user.errors.full_messages.first).to include(@event.name)
      end

      it 'allows deleting' do
        user.destroy
        expect(user.deleted?).to eq true
        expect(user.errors.full_messages).to be_empty
      end
    end
  end
end
