# frozen_string_literal: true

module Api
  class UserSerializableResource < ApplicationResource
    type 'users'

    # this is to make looking up the current user in the
    # ember store easy
    id { 'current-user' }

    attributes :first_name, :last_name,
               :email,
               :sign_in_count,
               :current_sign_in_at, :current_sign_in_ip,
               :confirmed_at, :confirmation_sent_at,
               :unconfirmed_email,
               :time_zone

    has_many :membership_renewals, class: '::Api::MembershipRenewalSerializableResource' do
      data do
        @object.renewals
      end
    end
  end
end
