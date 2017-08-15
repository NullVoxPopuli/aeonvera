# frozen_string_literal: true

module Api
  class MembershipRenewalSerializableResource < ApplicationResource
    type 'membership-renewals'

    attributes :start_date, :expires_at, :duration

    attribute(:expired) { @object.expired? }

    belongs_to :membership_option, class: '::Api::MembershipOptionSerializableResource' do
      linkage always: true
    end
    belongs_to :member, class: '::Api::MemberSerializableResource' do
      linkage always: true
      data { @object.user }
    end
  end
end
