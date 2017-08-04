# frozen_string_literal: true
module Api
  class OrganizationSerializableResource < ApplicationResource
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

    attribute(:url) { @object.link }
    attribute(:logo_url) { @object.logo.url(:original) }
    attribute(:logo_url_thumb) { @object.logo.url(:thumb) }
    attribute(:logo_url_medium) { @object.logo.url(:medium) }
    attribute(:has_stripe_integration) { @object.integrations[:stripe].present? }
    attribute(:accept_only_electronic_payments) { true }

    has_many :lessons, class: '::Api::LessonSerializableResource' do
      @object.available_lessons
    end

    has_many :integrations, class: '::Api::IntegrationSerializableResource'
    has_many :membership_options, class: '::Api::MembershipOptionSerializableResource'
    has_many :membership_discounts, class: '::Api::MembershipDiscountSerializableResource'
  end
end
