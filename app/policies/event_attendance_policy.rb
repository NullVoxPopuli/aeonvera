class EventAttendancePolicy < SkinnyControllers::Policy::Base
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

  # EventAttendancesController#index
  def read_all?
    is_collaborator?
  end

  # EventAttendancesController#show
  def read?
    object.attendee == user || is_collaborator?
  end

  # EventAttendancesController#create
  # def create?
  #   default? # SkinnyControllers.allow_by_default # aka "true"
  # end

  # EventAttendancesController#update
  def update?
    read?
  end

  # EventAttendancesController#destroy
  def delete?
    read?
  end

  private

  def is_collaborator?
    object.host.is_accessible_as_collaborator?(user)
  end
end
