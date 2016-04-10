class Api::EventsController < Api::ResourceController
  def index; show; end

  private

  def update_event_params
    result = ActiveModelSerializers::Deserialization
      .jsonapi_parse(params,
        only: [
          'name', 'short-description', 'domain',
          'starts-at', 'ends-at',
          'mail-payments-end-at', 'electronic-payments-end-at',
          'refunds-end-at', 'has-volunteers',
          'volunteer-description',
          'housing-status', 'housing-nights',
          'allow-discounts', 'shirt-sales-end-at',
          'show-at-the-door-prices-at', 'allow-combined-discounts',
          'location', 'show-on-public-calendar',
          'make-attendees-pay-fees', 'accept-only-electronic-payments',
          'logo',
          'registration-email-disclaimer'
      ])

    result
  end

  def create_event_params
    update_event_params
  end

end
