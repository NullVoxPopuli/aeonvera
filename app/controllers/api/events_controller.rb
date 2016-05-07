class Api::EventsController < Api::ResourceController
  def index; show; end

  private

  def update_event_params
    whitelistable_params(embedded: [:opening_tier]) do | whitelister |
      whitelister.permit(
        :name, :short_description, :domain,
        :starts_at, :ends_at,
        :mail_payments_end_at, :electronic_payments_end_at,
        :refunds_end_at, :has_volunteers,
        :volunteer_description,
        :housing_status, :housing_nights,
        :allow_discounts, :shirt_sales_end_at,
        :show_at_the_door_prices_at, :allow_combined_discounts,
        :location, :show_on_public_calendar,
        :make_attendees_pay_fees, :accept_only_electronic_payments,
        :logo,
        :registration_email_disclaimer,

        opening_tier_attributes: [
          :date
        ]
      )
    end
  end

  def create_event_params
    update_event_params
  end

end
