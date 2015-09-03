class CompetitionResponseSerializer < ActiveModel::Serializer

  attributes :id,
    :attendance_id, :attendance_type,
    :competition_id,
    :dance_orientation,
    :partner_name
end
