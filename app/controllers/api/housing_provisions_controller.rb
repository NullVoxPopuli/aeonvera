class Api::HousingProvisionsController < APIController
  include SetsEvent
  include LazyCrud


  set_resource HousingProvision
  set_resource_parent Event

  def index
    @housing_provisions = @event.housing_provisions
    respond_with @housing_provisions
  end
end
