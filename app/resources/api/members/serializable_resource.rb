# frozen_string_literal: true

module Api
  class MemberSerializableResource < ApplicationResource
    type 'members'

    attributes :first_name, :last_name, :email

    has_many :membership_renewals, class: '::Api::MembershipRenewalSerializableResource'
    has_many :memberships, class: '::Api::MembershipOptionSerializableResource'
  end
end
