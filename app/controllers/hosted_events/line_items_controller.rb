class HostedEvents::LineItemsController < ApplicationController
  include SetsEvent
  include LazyCrud

  set_resource LineItem
  set_resource_parent Event
  set_param_whitelist(
    :name, :price, :picture, :expires_at, :becomes_available_at
  )

  layout "edit_event"
end
