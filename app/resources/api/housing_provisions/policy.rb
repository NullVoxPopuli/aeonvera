# frozen_string_literal: true
module Api
  class HousingProvisionPolicy < SkinnyControllers::Policy::Base
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

    # HousingProvisionsController#index
    def read_all?
      is_user_a_collaborator?(object.first)
    end

    # HousingProvisionsController#show
    def read?
      is_user_a_collaborator? || is_the_attendee?
    end

    # HousingProvisionsController#create
    def create?
      is_user_a_collaborator? || is_the_attendee?
    end

    # HousingProvisionsController#update
    def update?
      is_user_a_collaborator? || is_the_attendee?
    end

    # HousingProvisionsController#destroy
    def delete?
      is_user_a_collaborator? || is_the_attendee?
    end

    private

    def is_user_a_collaborator?(o = object)
      return false unless o.try(:host)
      o.host.is_accessible_as_collaborator?(user)
    end

    def is_the_attendee?
      object.attendance.attendee_id == user.id
    end
  end
end
