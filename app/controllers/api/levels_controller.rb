class Api::LevelsController < Api::ResourceController
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
    attributes = update_level_params

    event_relationship = params
      .require(:data).require(:relationships)
      .require(:event).require(:data).permit(:id)

    attributes.merge(event_id: event_relationship[:id])
  end

end
