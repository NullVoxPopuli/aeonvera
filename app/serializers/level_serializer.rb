class LevelSerializer < ActiveModel::Serializer

  attributes :id, :event_id,
    :name,
    :number_of_leads, :number_of_follows,
    :requirement

    def number_of_follows
      object.attendances.follows.count
    end

    def number_of_leads
      object.attendances.leads.count
    end

    def requirement
      object.requirement_name
    end
end
