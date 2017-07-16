module Api
  class RegistrationPolicy < SkinnyControllers::Policy::Base

    # This is not a public api, prevent access
    def read_all?
      raise AeonVera::Errors::IncorrectPolicyCheck, 'Please validate collaborator read access to the event'
    end
  end
end
