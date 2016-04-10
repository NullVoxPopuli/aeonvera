class Api::PackagesController < Api::EventResourceController
  private

  def update_package_params
    ActiveModelSerializers::Deserialization
      .jsonapi_parse(params, only: [
        :name, :initial_price, :at_the_door_price,
        :attendee_limit, :expires_at, :requires_track,
        :ignore_pricing_tiers
      ])
  end

  # @example
  #   {"data"=>{
  #      "attributes"=>{
  #         "number_of_leads"=>nil, "number_of_follows"=>nil, "name"=>"", "requirement"=>2},
  #      "relationships"=>{"event"=>{"data"=>{"type"=>"events", "id"=>"16"}}},
  #    "type"=>"levels"}, "level"=>{}}
  def create_package_params
    ActiveModelSerializers::Deserialization
      .jsonapi_parse(params, only: [
        :name, :initial_price, :at_the_door_price,
        :attendee_limit, :expires_at, :requires_track,
        :ignore_pricing_tiers,
        :event
      ])
  end

end
