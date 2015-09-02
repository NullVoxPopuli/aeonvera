# object is actually an Organization in this serializer
class EventSerializer < ActiveModel::Serializer

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
    :url

    has_many :integrations

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

  # TODO: has_one permission_set?

end
