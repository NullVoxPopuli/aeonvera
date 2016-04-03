class CompetitionSerializer < ActiveModel::Serializer
  include PublicAttributes::CompetitionAttributes
  attributes :number_of_follows, :number_of_leads, :number_of_registrants

  # this mess is for getting the minimum data for a competition overview. gross.
  class OrderLineItemSerializer < ::OrderLineItemSerializer
    # override the top-level order-serializer, because it has
    # a lot of relationships that we don't care about right now
    class OrderSerializer < ActiveModel::Serializer
      attributes :id, :user_email, :user_name, :payment_received_at, :created_at

      class AttendanceSerializer < ActiveModel::Serializer
        attributes :id
      end

      # we just want to get to the associated attendance id
      belongs_to :attendance, serializer: ::CompetitionSerializer::OrderLineItemSerializer::OrderSerializer::AttendanceSerializer

      def user_email; object.buyer_email; end
      def user_name; object.buyer_name; end
    end

    class LineItemSerializer < ActiveModel::Serializer; end

    # override the superclass's serializer
    belongs_to :line_item, serializer: ::CompetitionSerializer::OrderLineItemSerializer::LineItemSerializer
    belongs_to :order, serializer: ::CompetitionSerializer::OrderLineItemSerializer::OrderSerializer
  end


  # attendances are not required for these, so we can't constrain
  has_many :order_line_items, serializer: ::CompetitionSerializer::OrderLineItemSerializer
  # has_many :attendances


  def order_line_items_with_attendances
    return @order_line_items if @order_line_items
    attending = Attendance.arel_table[:attending]
    @order_line_items = object
      .order_line_items.joins(order: :attendance)
      .where(attending.eq(true))
  end

  def attendances
    return @attendances if @attendances
    @attendances = order_line_items_with_attendances
      .map{ |order_line_item| order_line_item.order.attendance }
      .uniq{ |attendance| attendance.id }

    @attendances
  end

  def number_of_registrants
    object.order_line_items.count
  end

  def number_of_leads
    order_line_items_with_attendances
      .where(dance_orientation: Attendance::LEAD)
      .count
  end

  def number_of_follows
    order_line_items_with_attendances
      .where(dance_orientation: Attendance::FOLLOW)
      .count
  end
end
