class CompetitionSerializer < ActiveModel::Serializer

  attributes :id, :name,
    :initial_price, :at_the_door_price, :current_price,
    :kind, :kind_name,
    :requires_orientation, :requires_partner,
    :event_id,
    :number_of_follows, :number_of_leads,
    :number_of_registrants

    def number_of_registrants
      attending = Attendance.arel_table[:attending]
      object
        .order_line_items.joins(order: :attendance)
        .where(attending.eq(true)).count
    end

    def number_of_leads
      attending = Attendance.arel_table[:attending]
      object
        .order_line_items.joins(order: :attendance)
        .where(dance_orientation: Attendance::LEAD)
        .where(attending.eq(true)).count
    end

    def number_of_follows
      attending = Attendance.arel_table[:attending]
      object
        .order_line_items.joins(order: :attendance)
        .where(dance_orientation: Attendance::FOLLOW)
        .where(attending.eq(true)).count
    end

    def requires_orientation
      object.requires_orientation?
    end

    def requires_partner
      object.requires_partner?
    end
end
