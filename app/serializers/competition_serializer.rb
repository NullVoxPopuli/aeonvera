class CompetitionSerializer < ActiveModel::Serializer

  attributes :id, :name,
    :initial_price, :at_the_door_price, :current_price,
    :kind, :kind_name,
    :requires_orientation, :requires_partner,
    :event_id,
    :competition_response_ids



    def requires_orientation
      object.requires_orientation?
    end

    def requires_partner
      object.requires_partner?
    end
end
