module Policies
  class LineItemPolicy < Base
    def read?
      object.host.is_accessible_to? user
    end
  end
end
