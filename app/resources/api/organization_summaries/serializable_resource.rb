# frozen_string_literal: true

module Api
  # object is actually an OrganizationSummaryPresenter
  class OrganizationSummarySerializableResource < ApplicationResource
    include SharedAttributes::HasLogo

    type 'organization-summaries'

    attributes :name, :domain,
               :revenue_past_month, :net_received_past_month,
               :unpaid_past_month, :new_memberships_past_month

    has_many :orders, class: '::Api::OrderSerializableResource'
  end
end
