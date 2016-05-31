module CollaborationOperations
  class AcceptInvitation < SkinnyControllers::Operation::Base
    include CollaborationOperations::Helpers

    def run
      return collaboration if collaboration.errors.present?

      if cache_key_is_valid
        if can_be_collaborator?
          # push the user in to the collaborators list
          host.collaborators << current_user
        else
          msg = "You are already helping with this #{host.class.name}"
          collaboration.errors.add(:base, msg)
        end

        clear_cache_key
      else
        msg = 'Key not found or your user is not associated with the invited email'
        collaboration.errors.add(:base, msg)
      end

      collaboration
    end

    def clear_cache_key
      Cache.delete(cache_key)
      Cache.delete("#{cache_key}-email")
    end

    # make sure this person is not already a collaborator
    # and that the current_uer is not the owner of the
    # event or organization
    def can_be_collaborator?
      !host.collaborators.include?(current_user) && !current_user_owns_host?
    end

    # TODO: these two objects (Event and Organization)
    # should really implement a common interface for this type of thing
    def current_user_owns_host?
      id = host.try(:hosted_by_id) || host.try(:owner_id)
      id == current_user.id
    end

    def cache_key_is_valid?
      Cache.get(cache_key) && Cache.get("#{cache_key}-email") == current_user.email
    end

    def cache_key
      @cache_key ||= "#{host.class.name}-#{host.id}-#{params[:token]}"
    end
  end
end
