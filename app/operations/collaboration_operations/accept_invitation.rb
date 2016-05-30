module CollaborationOperations
  class AcceptInvitation < SkinnyController::Operation::Base
    def run
      # just something to keep track of errors for the UI
      collaboration = Collaboration.new
      unless host
        collaboration.errors.add(:base, 'event or organization not found')
      end

      if cache_key_is_valid


        if can_be_collaborator?
          # push the user in to the collaborators list
          host.collaborators << current_user
        else
          msg = "You are already helping with this #{host.class.name}"
          collaboration.errors.add(:base, msg)
        end

        # reduce cache bloat
        Cache.delete(key)
        Cache.delete("#{key}-email")

        # redirect to the event the person was just added to
        path = hosted_event_path(@host.id)
        path = organization_path(@host.id) if @host.is_a?(Organization)

        return redirect_to path
      else
        msg = "Key not found or your user is not associated with the invited email"
        collaboration.errors.add(:base, msg)
      end

      redirect_to root_path
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
      Cache.get(cache_key) and Cache.get("#{cache_key}-email") == current_user.email
    end

    def cache_key
      @cache_key ||= "#{host.class.name}-#{host.id}-#{params[:token]}"
    end

    def host
      @host ||= find_host
    end

    def find_host
      kind = params[:host_type]
      if [Event.name, Organization.name].includes?(kind)
        klass = kind.safe_constantize
        klass.find(params[:host_id]) if klass
      end
    end
  end
end
