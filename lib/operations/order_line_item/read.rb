module Operations
  class OrderLineItem::Read < Base
    def run
      model if valid?
    end

    def valid?
      model.order.event.is_accessible_to?(current_user)
    end
  end
end
