class Api::Events::PackagesController < APIController
  include SetsEvent
  include LazyCrud

  set_resource_parent Event

end
