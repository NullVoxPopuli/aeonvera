module Api
  class CollaborationPolicy < SkinnyControllers::Policy::Base
    include OwnershipChecks

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
    def readall?; read_all?; end; # wut

    # CollaborationsController#index
    def read_all?
      # for read_all, the host/parent is passed
      # TODO: should this use the host policy?
      object.is_accessible_as_collaborator?(user)
    end

    # CollaborationsController#show
    def read?
      is_at_least_a_collaborator?
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

    def is_at_least_a_collaborator?
      super(object.collaborated)
    end

    def is_owner?
      super(object.collaborated)
    end
  end
end
