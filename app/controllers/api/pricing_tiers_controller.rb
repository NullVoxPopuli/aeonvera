class Api::PricingTiersController < APIController
  include SetsEvent
  include LazyCrud

  set_resource_parent Event

  def index
    @pricing_tiers = resource_proxy
    render json: @pricing_tiers, include: params[:include]
  end

  private

  def resource_proxy
    # current_user.hosted_and_collaborated_events
    current_user.hosted_events.find(params[:event_id]).pricing_tiers
  end
end
