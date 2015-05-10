class HostedEvents::CustomFieldsController < ApplicationController
  include SetsEvent
  include LazyCrud

  set_resource CustomField
  set_resource_parent Event
  set_param_white_list(
    :label, :kind, :default_value, :editable
  )


end
