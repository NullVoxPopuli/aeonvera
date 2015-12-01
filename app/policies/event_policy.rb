class EventPolicy < SkinnyControllers::Policy::Base
  class SubConfiguration < SkinnyControllers::Policy::Base
    def read?
      parent.is_accessible_to? user
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

    def parent
      object.try(:event) || object.try(:host)
    end
  end
end
