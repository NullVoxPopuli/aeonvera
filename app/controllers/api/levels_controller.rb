class Api::LevelsController < APIController
  include SkinnyControllers::Diet

  def index
    render json: model, include: params[:include]
  end

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

  def update
    render json: model, status: status
  end

  def destroy
    render json: model
  end

  private

  def update_level_params
    params
      .require(:data)
      .require(:attributes)
      .permit(:name, :requirement)
  end

  # @example
  #   {"data"=>{
  #      "attributes"=>{
  #         "number_of_leads"=>nil, "number_of_follows"=>nil, "name"=>"", "requirement"=>2},
  #      "relationships"=>{"event"=>{"data"=>{"type"=>"events", "id"=>"16"}}},
  #    "type"=>"levels"}, "level"=>{}}
  def create_level_params
    attributes = params
      .require(:data)
      .require(:attributes)
      .permit(:name, :requirement)

    event_relationship = params
      .require(:data).require(:relationships)
      .require(:event).require(:data).permit(:id)

    attributes.merge(event_id: event_relationship[:id])
  end

  def status
    model.errors.present? ? 422 : 200
  end

end
