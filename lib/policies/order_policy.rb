module Policies
  class OrderPolicy < Base
    def read?(order = object)
      order.is_accessible_to? user
    end

    def read_all?
      # TODO: come up with some way to see if we
      # only care about the parent object's authorization
      true
    end
  end
end
