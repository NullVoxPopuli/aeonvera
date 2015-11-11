module Policies
  class EventPolicy < Base
    def read?
      object.is_accessible_to? user
    end
  end
end
