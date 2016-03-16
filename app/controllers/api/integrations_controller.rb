class Api::IntegrationsController < APIController
  include SkinnyControllers::Diet

  def show
    render json: model
  end

  def create
    if model.errors.present?
      render json: model.errors.to_json_api, status: 422
    else
      render json: model
    end
  end

  def destroy
    render json: model
  end

  private

  def create_integration_params
    attributes = params
      .require(:data)
      .require(:attributes)
      .permit(:authorization_code, :kind)

    owner_relationship = params
      .require(:data).require(:relationships)
      .require(:owner).require(:data).permit(:id, :type)

    type = owner_relationship[:type]
    type = type == 'event' ? 'Event' : 'Organization'

    attributes.merge(owner_id: owner_relationship[:id], owner_type: type)
  end
end
