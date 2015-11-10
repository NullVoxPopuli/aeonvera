module Policies
  class OrderLineItemPolicy < Base
    def read?
      object.order.event.is_accessible_to? user
    end
  end
end
