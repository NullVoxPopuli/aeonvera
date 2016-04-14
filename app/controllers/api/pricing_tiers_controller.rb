class Api::PricingTiersController < Api::EventResourceController
  private

  # The fields are named different on teh server than the client
  def update_pricing_tier_params
    rp = ActiveModelSerializers::Deserialization
      .jsonapi_parse(params, only: [
        :increase_by_dollars,
        :date, :increase_after_date,
        :registrants, :increase_by])

    rp[:increase_by_dollars] = rp[:increase_by] unless rp[:increase_by_dollars]
    rp[:date] = rp[:increase_after_date] unless rp[:date]
    rp[:registrants] = rp[:increase_after_total_registrants] unless rp[:date]
    rp.slice(*PricingTier.columns.map(&:name))
  end

  def create_pricing_tier_params
    attributes = update_pricing_tier_params

    event_relationship = params
      .require(:data).require(:relationships)
      .require(:event).require(:data).permit(:id)

    attributes.merge(event_id: event_relationship[:id])
  end
end
