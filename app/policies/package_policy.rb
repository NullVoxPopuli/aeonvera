class PackagePolicy < SkinnyControllers::Policy::Base
  def read?
    object.event.is_accessible_to? user
  end
end
