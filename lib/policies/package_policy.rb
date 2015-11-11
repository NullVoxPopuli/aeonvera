module Policies
  class PackagePolicy < Base
    def read?
      object.order.event.is_accessible_to? user
    end
  end
end
