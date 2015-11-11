module Policies
  class CompetitionPolicy < Base
    def read?
      object.event.is_accessible_to? user
    end
  end
end
