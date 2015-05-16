class HostedEvents::LevelsController < ApplicationController
  include SetsEvent
  include LazyCrud

  set_resource Level
  set_resource_parent Event
  set_param_whitelist(:name, :requirement, :sequence)


  layout "edit_event"

end
