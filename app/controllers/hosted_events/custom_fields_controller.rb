class HostedEvents::CustomFieldsController < ApplicationController
  include SetsEvent
  include LazyCrud

  set_resource CustomField
  set_resource_parent Event
  set_param_whitelist(
    :label, :kind, :default_value, :editable
  )
  

  layout "edit_event"

  def before_create
    @custom_field.user = current_user
  end

end
