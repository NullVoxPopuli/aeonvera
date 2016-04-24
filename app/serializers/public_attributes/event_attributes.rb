module PublicAttributes
  module EventAttributes
    extend ActiveSupport::Concern

    included do
      attributes :id, :name,
        :short_description, :location,
        :domain,
        :starts_at, :ends_at,
        :mail_payments_end_at,
        :electronic_payments_end_at,
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
        :logo_url_thumb, :logo_url_medium, :logo_url,
        :url, :has_stripe_integration,
        :ask_if_leading_or_following

      belongs_to :opening_tier, serializer: OpeningTierSerializer
      belongs_to :current_tier
      has_many :pricing_tiers
      has_many :integrations
      has_many :packages
      has_many :levels
      has_many :competitions
      has_many :line_items
      has_many :custom_fields
      has_many :shirts, serializer: ShirtSerializer
    end



    def has_stripe_integration
      object.integrations[:stripe].present?
    end

    def url
      object.url
    end

    def logo_url_thumb
      object.logo.url(:thumb)
    end

    def logo_url_medium
      object.logo.url(:medium)
    end

    def logo_url
      object.logo.url(:original)
    end
  end
end
