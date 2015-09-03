# object is actually an Attendance in this serializer
class LineItemSerializer < ActiveModel::Serializer

  attributes :id,
    :name, :current_price, :price  


end
