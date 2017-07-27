module Api
  # object is actually an Attendance in this serializer
  class LineItemSerializer < ActiveModel::Serializer
    include PublicAttributes::LineItemAttributes
    include SharedAttributes::Stock

    has_many :registrations
    has_many :order_line_items
  end
end
