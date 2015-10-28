# object is actually an Attendance in this serializer
class LineItemSerializer < ActiveModel::Serializer

  attributes :id,
    :name, :current_price, :price,
    :host_id, :host_type,
    :event_id, :number_purchased


    def event_id
      object.host_id
    end


    def number_purchased
      object.order_line_items.count
    end



end
