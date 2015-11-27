class PackagePolicy < SkinnyControllers::Policy::Base
  def read?
    object.event.is_accessible_to? user
  end

  def update?
    object.event.hosted_by == user
  end

  def delete?
    object.event.hosted_by == user
  end

  def create?
    object.event.hosted_by == user
  end
end
