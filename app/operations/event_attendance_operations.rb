module EventAttendanceOperations

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

  # EventAttendancesController#create
  class Create < SkinnyControllers::Operation::Base
    include HelperOperations::Helpers

    def run
      ap params_for_action
      host = host_from_params(params_for_action)
      @model = host.attendances.new(params_for_action)
      # TODO: if we are setting the attendee if, make sure the current_user
      # has permission to do so
      @model.attendee = current_user unless params_for_action[:attendee_id]
      # TODO: verify level and package belong to the event
      @model.save
      @model
    end
  end
  #
  # # EventAttendancesController#index
  # class ReadAll < SkinnyControllers::Operation::Base
  #   def run
  #     # model is a list of model_class instances
  #     model if allowed?
  #   end
  # end
  #
  # # EventAttendancesController#show
  # class Read < SkinnyControllers::Operation::Base
  #   def run
  #     model if allowed?
  #   end
  # end
  #
  # # EventAttendancesController#update
  # class Update < SkinnyControllers::Operation::Base
  #   def run
  #     model.update(model_params) if allowed?
  #   end
  # end
  #
  # # EventAttendancesController#destroy
  # class Delete < SkinnyControllers::Operation::Base
  #   def run
  #     model.destroy if allowed?
  #   end
  # end
end
