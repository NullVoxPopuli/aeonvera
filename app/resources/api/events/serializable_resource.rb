# frozen_string_literal: true

module Api
  class EventSerializableResource < ApplicationResource
    type 'events'

    attributes(:name,
               :short_description, :location,
               :website,
               :domain,
               :starts_at, :ends_at,
               :mail_payments_end_at,
               :electronic_payments_end_at,
               :online_competition_sales_end_at,
               :accept_only_electronic_payments,
               :refunds_end_at,
               :has_volunteers, :volunteer_description,
               :housing_status, :housing_nights,
               :allow_discounts, :allow_combined_discounts,
               :shirt_sales_end_at,
               :show_at_the_door_prices_at,
               :show_on_public_calendar,
               :make_attendees_pay_fees,
               :registration_email_disclaimer,
               :logo_file_name, :logo_content_type,
               :logo_file_size, :logo_updated_at,
               :ask_if_leading_or_following, :contact_email)

    attribute(:url) { @object.url }
    attribute(:logo_url_thumb) { @object.logo.url(:thumb) }
    attribute(:logo_url_medium) { @object.logo.url(:medium) }
    attribute(:logo_url) { @object.logo.url(:original) }
    attribute(:has_stripe_integration) { @object.integrations[:stripe].present? }

    belongs_to :opening_tier, class: '::Api::PricingTierSerializableResource'
    belongs_to :current_tier, class: '::Api::PricingTierSerializableResource'

    has_many :registrations, class: '::Api::Users::RegistrationSerializableResource'
    has_many :pricing_tiers, class: '::Api::PricingTierSerializableResource'
    has_many :integrations, class: '::Api::IntegrationSerializableResource'
    has_many :packages, class: '::Api::PackageSerializableResource'
    has_many :levels, class: '::Api::LevelSerializableResource'
    has_many :competitions, class: '::Api::CompetitionSerializableResource'
    has_many :line_items, class: '::Api::LineItemSerializableResource'
    has_many :custom_fields, class: '::Api::CustomFieldSerializableResource'
    has_many :shirts, class: '::Api::ShirtSerializableResource'
    has_many :sponsorships, class: '::Api::SponsorshipSerializableResource'
  end
end
