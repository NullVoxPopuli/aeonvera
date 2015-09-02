class CompetitionResponseSerializer < ActiveModel::Serializer

  attributes :id, :name,
    :attendance_id, :attendance_type,
    :competition_id,
    :dance_orientation,
    :partner_name

    def requires_orientation
      object.requires_orientation?
    end

    def requires_partner
      object.requires_partner?
    end
end
