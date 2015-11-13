module Policies
  class OrderPolicy < Base
    def read?(order = object)
      order.is_accessible_to? user
    end

    alias_method :send_confirmation_of_received_payment?

    def read_all?
      return true if authorized_via_parent
      accessible = object.map { |order| read?(order) }
      accessible.all?
    end
  end
end
