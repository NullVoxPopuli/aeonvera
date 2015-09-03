# object is actually an Attendance in this serializer
class LineItemSerializer < ActiveModel::Serializer

  attributes :id,
    :name, :current_price, :price,
    :host_id, :host_type,
    :event_id


    def event_id
      object.host_id
    end



end
