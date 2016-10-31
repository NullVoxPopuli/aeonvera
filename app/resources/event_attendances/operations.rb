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
      # these two are not actually a part of the attendance,
      # but are used to find/create a user to assign to
      # this new attendance
      email = params_for_action.delete(:attendee_email)
      name = params_for_action.delete(:attendee_name)

      host = host_from_params(params_for_action)
      @model = host.attendances.new(params_for_action)
      @model.attendee = attendee_for(email, name)

      unless @model.attendee || !name
        name_parts = name.split(' ')
        # Trigger Validations, rather than throw exception
        @model.metadata['first_name'] = name_parts.try(:[], 0)
        @model.metadata['last_name'] = name_parts.try(:[], 1)
      end

      # TODO: if attendee is nil, should housing be skipped?
      # (yes)
      map_inferred_relationships(host: host, attendance: @model)

      # TODO: verify level and package belong to the event
      @model.save
      @model
    end

    # Given an email address and name, we could look up the user
    # to see if they already have an account.
    #
    # If they don't have an account, a user will be created for them,
    # and they will receive an email asking them to create their account.
    #
    # If no email is provided, we assign to current_user
    def attendee_for(email = nil, name = nil)
      # Assume current user if neither email nor name are provided
      return current_user if email.blank? && name.blank?

      # Assume we are creating a registration not tied to a user if
      # we don't have an email to work with
      # (could this ever backfire?)
      return nil if name.present? && email.blank?

      # TODO: if we are creating a new user, make sure the current_user
      # has permission to do so.
      user = User.find_by_email(email)
      return user if user

      # couldn't find the user by email, and in order to create one,
      # we need first name and last name
      return nil unless name
      name_parts = name.split(' ')

      # user doesn't exist, create
      User.create(
        first_name: name_parts.first,
        last_name: name_parts.last,
        email: email,
        password: 'change me please'
      )
    end

    # hook up relatioships all over the place
    def map_inferred_relationships(host: nil, attendance: nil)
      map_housing_request_relationships(host: host, attendance: attendance)
      map_housing_provision_relationships(host: host, attendance: attendance)
    end

    def map_housing_request_relationships(host: nil, attendance: nil)
      if attendance.housing_request
        attendance.housing_request.host = host

        # set the polymorphic relationship
        attendance.housing_request.attendance = attendance
      end
    end

    def map_housing_provision_relationships(host: nil, attendance: nil)
      if attendance.housing_provision
        attendance.housing_provision.host = host

        # set the polymorphic relationship
        attendance.housing_provision.attendance = attendance
      end
    end
  end

  # # EventAttendancesController#index
  # class ReadAll < SkinnyControllers::Operation::Base
  #   def run
  #     # model is a list of model_class instances
  #     model if allowed?
  #   end
  # end

  # # EventAttendancesController#show
  # class Read < SkinnyControllers::Operation::Base
  #   def run
  #     model if allowed?
  #   end
  # end

  # EventAttendancesController#update
  class Update < SkinnyControllers::Operation::Base
    def run
      model.update(params_for_action) if allowed?
      model
    end
  end

  class Checkin < Update
    # TODO: only event collaborators can check someone in
  end

  # # EventAttendancesController#destroy
  # class Delete < SkinnyControllers::Operation::Base
  #   def run
  #     model.destroy if allowed?
  #   end
  # end
end
