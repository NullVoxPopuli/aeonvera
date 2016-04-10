# object is actually an Attendance in this serializer
class LineItemSerializer < ActiveModel::Serializer
  include PublicAttributes::LineItemAttributes

  has_many :attendances
end
