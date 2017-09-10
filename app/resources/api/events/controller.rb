# frozen_string_literal: true

module Api
  class EventsController < ResourceController
    self.serializer = EventSerializableResource
    self.default_fields = {
      # events: [:opening_tier, :current_tier, :integrations, :sponsorships],
      levels: [:id, :name, :requirement, :description],
      'opening-tiers': [:date, :registrants, :increase_by_dollars, :is_opening_tier],
      'pricing-tiers': [:date, :registrants, :increase_by_dollars, :is_opening_tier]

    }

    def index
      show
    end

    def show
      model = EventOperations::Read.new(current_user, params).run
      render_jsonapi(model: model)
    end

    private

    def update_event_params
      whitelistable_params(embedded: [
                             :opening_tier, :sponsorship
                           ]) do |whitelister|
        whitelister.permit(
          :name, :short_description, :domain,
          :starts_at, :ends_at,
          :mail_payments_end_at, :electronic_payments_end_at,
          :online_competition_sales_end_at,
          :refunds_end_at, :has_volunteers,
          :volunteer_description,
          :housing_status, :housing_nights,
          :allow_discounts, :shirt_sales_end_at,
          :show_at_the_door_prices_at, :allow_combined_discounts,
          :location, :show_on_public_calendar,
          :website,
          :make_attendees_pay_fees, :accept_only_electronic_payments,
          :logo,
          :logo_file_name, :logo_file_size,
          :logo_updated_at, :logo_content_type,
          :registration_email_disclaimer,
          :contact_email,

          opening_tier_attributes: [
            :date
          ],

          sponsorship_attributes: [
            :sponsor_id, :sponsor_type, :discount_id, :discount_type
          ]
        )
      end
    end

    def create_event_params
      update_event_params
    end
  end
end
