class Api::CustomFieldsController < APIController

  include SetsEvent

  def index
    render json: @event.custom_fields, include: params[:include]
  end

end
