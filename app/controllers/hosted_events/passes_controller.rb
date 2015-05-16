class HostedEvents::PassesController < ApplicationController
  include SetsEvent
  include LazyCrud

  set_resource Pass
  set_resource_parent Event
  set_param_whitelist(
    :name, :attendance_id, :intended_for,
    :percent_off, :discountable_id, :discountable_type
  )


  layout "hosted_events"
end
