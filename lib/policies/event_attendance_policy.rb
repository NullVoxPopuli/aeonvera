module Policies
  class EventAttendancePolicy < Base
    def read?(order = object)
      order.is_accessible_to? user
    end

    def read_all?
      return true if authorized_via_parent
      accessible = object.map { |ea| read?(ea) }
      accessible.all?
    end
  end
end
