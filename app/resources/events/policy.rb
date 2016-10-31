class EventPolicy < SkinnyControllers::Policy::Base
  class SubConfiguration < SkinnyControllers::Policy::Base
    def read?(o = object)
      parent(o).is_accessible_to? user
    end

    def update?
      parent && parent.hosted_by == user
    end

    def delete?
      parent && parent.hosted_by == user
    end

    def create?
      parent && parent.hosted_by == user
    end

    private

    def parent(o = object)
      o.try(:event) || o.try(:host)
    end
  end
end
