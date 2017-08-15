# frozen_string_literal: true

module Api
  module EventFields
    PUBLIC_ATTRIBUTES = [
      :name,
      :short_description, :location,
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
      :ask_if_leading_or_following, :contact_email,
      :url, :logo_url_thumb, :logo_url_medium, :logo_url,
      :has_stripe_integration
    ].freeze

    PUBLIC_RELATIONSHIPS = [
      :packages, :competitions, :levels,
      :pricing_tiers, :opening_tier,
      :custom_fields
    ].freeze

    PUBLIC_FIELDS = [*PUBLIC_ATTRIBUTES, *PUBLIC_RELATIONSHIPS].freeze
  end
end
