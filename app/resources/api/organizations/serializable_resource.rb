# frozen_string_literal: true

module Api
  class OrganizationSerializableResource < ApplicationResource
    include SharedAttributes::HasLogo

    type 'organizations'

    attributes :name, :tagline,
               :city, :state, :beta, :owner_id,
               :domain,
               :logo_file_name, :logo_content_type,
               :logo_file_size, :logo_updated_at,
               :make_attendees_pay_fees,
               :notify_email,
               :email_all_purchases,
               :email_membership_purchases,
               :contact_email

    # Attributes that require a presenter
    attribute(:revenue_past_month) { @object.try(:revenue_past_month) }
    attribute(:net_received_past_month) { @object.try(:net_received_past_month) }
    attribute(:unpaid_past_month) { @object.try(:unpaid_past_month) }
    attribute(:new_memberships_past_month) { @object.try(:new_memberships_past_month) }

    attribute(:url) { @object.link }
    attribute(:has_stripe_integration) { @object.integrations[:stripe].present? }
    attribute(:accept_only_electronic_payments) { true }

    has_many :lessons, class: '::Api::LessonSerializableResource' do
      data { @object.available_lessons }
    end

    has_many :integrations, class: '::Api::IntegrationSerializableResource'
    has_many :membership_options, class: '::Api::MembershipOptionSerializableResource'
    has_many :membership_discounts, class: '::Api::MembershipDiscountSerializableResource'

    has_many :recent_orders, class: '::Api::OrderSerializableResource' do
      data { @object.orders.last(10) }
    end
  end
end
