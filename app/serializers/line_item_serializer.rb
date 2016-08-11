# object is actually an Attendance in this serializer
class LineItemSerializer < ActiveModel::Serializer
  include PublicAttributes::LineItemAttributes

  has_many :attendances
  has_many :order_line_items
end
