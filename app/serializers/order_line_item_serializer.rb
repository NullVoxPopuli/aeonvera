class OrderLineItemSerializer < ActiveModel::Serializer
  type 'order-line-item'
  attributes :id, :price, :quantity, :order_id, :dance_orientation, :partner_name, :size, :color

  class LineItemSerializer < ActiveModel::Serializer
    type proc { |object|
      k = object.class.name.underscore.dasherize.downcase
      k.gsub('line-item/', '') # cause ember doesn't have nesting
    }

    attributes :id, :name, :amount

    has_many :restraints
    def restraints
      # not all line items have restraints
      # though, they probably should
      object.try(:restraints) || []
    end

    def amount
      # hack for discounts :-(
      object.try(:amount)
    end
  end

  belongs_to :line_item, serializer: OrderLineItemSerializer::LineItemSerializer
  belongs_to :order
end
