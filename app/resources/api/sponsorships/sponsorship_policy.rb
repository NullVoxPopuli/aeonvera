# frozen_string_literal: true

module Api
  class SponsorshipPolicy < SkinnyControllers::Policy::Base
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

    # SponsorshipsController#index
    def read_all?
      default? # SkinnyControllers.allow_by_default # aka "true"
    end

    # SponsorshipsController#show
    def read?
      default? # SkinnyControllers.allow_by_default # aka "true"
    end

    # SponsorshipsController#create
    def create?
      owns_either?
    end

    # SponsorshipsController#update
    def update?
      owns_either?
    end

    # SponsorshipsController#destroy
    def delete?
      owns_either?
    end

    private

    def owns_either?
      owns_sponsor? || owns_sponsored?
    end

    def owns_sponsor?
      object.sponsor.user == user
    end

    def owns_sponsored?
      object.sponsored.user == user
    end
  end
end
