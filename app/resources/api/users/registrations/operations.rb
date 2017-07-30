# frozen_string_literal: true

module Api
  module Users
    module RegistrationOperations
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
      class Create < SkinnyControllers::Operation::Base
        include HelperOperations::Helpers

        # TODO: this is complicated....
        # def resource_proxy
        #   Registration.includes(
        #     :housing_request,
        #     :housing_provision,
        #     { host: [:pricing_tiers, :packages] },
        #     { orders: [order_line_items: [:line_item] ] },
        #     :level,
        #     :custom_field_responses
        #   ).where(attendee: current_user)
        # end
        def run
          model = current_user.registrations.new(params_for_action)
          form = RegistrationForms::Create.new(model)
          valid = form.validate(params_for_action)

          sync_form_and_model(form, model) unless valid

          valid && model.save

          model
        end
      end

      class Update < SkinnyControllers::Operation::Base
        def run
          model = current_user.registrations.find(params[:id])

          model.update(params_for_action) if allowed?
          model
        end
      end

      class Delete < SkinnyControllers::Operation::Base
        def run
          model = current_user.registrations.find(params[:id])

          paids = model.orders.map(&:paid)
          allowed_to_destroy = paids.empty? || paids.all?

          raise AeonVera::Errors::BeforeHookFailed unless allowed_to_destroy

          model.destroy
        end
      end
    end
  end
end
