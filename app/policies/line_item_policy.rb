class LineItemPolicy < SkinnyControllers::Policy::Base
  def read?
    object.host.is_accessible_to? user
  end
end
