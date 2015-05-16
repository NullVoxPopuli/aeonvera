class HostedEvents::DiscountsController < ApplicationController
  include SetsEvent
  include LazyCrud

  set_resource Discount
  set_resource_parent Event
  set_param_whitelist(
    :value, :name, :kind, :affects, :allowed_number_of_uses
  )

  layout "edit_event"

end
