# frozen_string_literal: true
module Api
  class LessonPolicy < SkinnyControllers::Policy::Base
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

    # LessonsController#index
    def read_all?
      default? # SkinnyControllers.allow_by_default # aka "true"
    end

    # LessonsController#show
    def read?
      default? # SkinnyControllers.allow_by_default # aka "true"
    end

    # LessonsController#create
    def create?
      is_at_least_a_collaborator? # SkinnyControllers.allow_by_default # aka "true"
    end

    # LessonsController#update
    def update?
      is_at_least_a_collaborator? # SkinnyControllers.allow_by_default # aka "true"
    end

    # LessonsController#destroy
    def delete?
      is_at_least_a_collaborator? # SkinnyControllers.allow_by_default # aka "true"
    end

    private

    def is_at_least_a_collaborator?
      result = object.host.is_accessible_as_collaborator?(user)
      unless result
        # This could be a validation if it didn't require the current user object
        object.errors.add(:host, 'is not an organization you collaborate on')
      end
      result
    end
  end
end
