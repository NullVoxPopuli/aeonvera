class HostedEvents::PricingTiersController < ApplicationController
  include SetsEvent
  include LazyCrud

  set_resource PricingTier
  set_resource_parent Event
  set_param_whitelist(
    :increase_by_dollars, :date, :registrants, package_ids: []
  )


  layout "edit_event"

end
