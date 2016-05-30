class CollaborationPolicy < SkinnyControllers::Policy::Base

  # Below are all the available permissions. Each permission corresponds
  # to an action in the controller.
  # Default functionality is to return true (allow) -- so the methods
  # below do not need to exist, unless you want to add custom logic
  # to them.
  #
  # The following variables are available to you in each policy
  # - object - the object the user is trying to access.
  # - user - the current user
  #

  # CollaborationsController#index
  def read_all?
    default? # SkinnyControllers.allow_by_default # aka "true"
  end

  # CollaborationsController#show
  def read?
    default? # SkinnyControllers.allow_by_default # aka "true"
  end

  # CollaborationsController#create
  def create?
    is_owner?
  end

  # CollaborationsController#update
  def update?
    is_owner?
  end

  # CollaborationsController#destroy
  def delete?
    is_owner?
  end

  private

  def is_owner?
    id = object.try(:hosted_by_id) || object.try(:owner_id)
    id == user.id
  end
end
