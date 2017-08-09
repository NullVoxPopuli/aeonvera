# frozen_string_literal: true

module Api
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
    #   include HelperOperations::Helpers
    #   def run
    #     model if allowed?
    #   end
    #
    #   def find_model
    #     host.collaborations
    #   end
    #
    #   def host
    #     @host ||= host_from_params(params)
    #   end
    # end

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
end
