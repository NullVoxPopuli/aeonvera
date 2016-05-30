module CollaborationOperations

  # Below are all the available actions an Operation can have.
  # These directly correlate to the controller actions.  None of
  # the operations below are required. Default functionality is basic CRUD,
  # and to always allow the model object to return.
  # See: SkinnyControllers::Operation::Default#run
  #
  # NOTE: If each operation gets big enough, it may be desirable to
  #       move each operation in to its own file.
  #
  # In every operation, the following variables are available to you:
  # - current_user
  # - params
  # - params_for_action - params specific to the action, if configured
  # - action - current controller action
  # - model_key - the underscored model_name
  # - model_params - params based on the model_key in params
  #
  # Methods:
  # - allowed? - calls allowed_for?(model)
  # - allowed_for? - allows you to pass an object to the policy that corresponds
  #                  to this operation

  # # CollaborationsController#create
  # class Create < SkinnyControllers::Operation::Base
  #   def run
  #    # @model is used here, because the `model` method is memoized using
  #    # the @model instance variable
  #    @model = model_class.new(model_params)
  #    @model.save
  #    @model
  #   end
  # end
  #
  # # CollaborationsController#index
  # class ReadAll < SkinnyControllers::Operation::Base
  #   def run
  #     # model is a list of model_class instances
  #     model if allowed?
  #   end
  # end

  class AcceptInvitation < SkinnyController::Operation::Base
    def run
      # look up token
      key = "#{@host.class.name}-#{@host.id}-#{params[:token]}"
      if Cache.get(key) and Cache.get("#{key}-email") == current_user.email

        # make sure this person is not already a collaborator
        # and that the current_uer is not the owner of the
        # event or organization
        if (not @host.collaborators.include?(current_user)) && @host.hosted_by != current_user
          # push the user in to the collaborators list
          @host.collaborators << current_user
          flash[:notice] = "You are now helping with this #{@host.class.name}"
        else
          flash[:notice] = "You are already helping with this #{@host.class.name}"
        end

        # reduce cache bloat
        Cache.delete(key)
        Cache.delete("#{key}-email")

        # redirect to the event the person was just added to
        path = hosted_event_path(@host.id)
        path = organization_path(@host.id) if @host.is_a?(Organization)

        return redirect_to path
      else
        flash[:notice] = "Key not found or your user is not associated with the invited email"
      end

      redirect_to root_path
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
  #
  # # CollaborationsController#show
  # class Read < SkinnyControllers::Operation::Base
  #   def run
  #     model if allowed?
  #   end
  # end
  #
  # # CollaborationsController#update
  # class Update < SkinnyControllers::Operation::Base
  #   def run
  #     model.update(model_params) if allowed?
  #   end
  # end
  #
  # # CollaborationsController#destroy
  # class Delete < SkinnyControllers::Operation::Base
  #   def run
  #     model.destroy if allowed?
  #   end
  # end
end
