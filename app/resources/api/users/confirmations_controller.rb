module Api
  module Users
    class ConfirmationsController < Devise::ConfirmationsController
      include Controllers::DeviseOverrides
      respond_to :html, :json

      # POST /resource/confirmation
      def create
        self.resource = resource_class.send_confirmation_instructions(params[:user])
        respond_with(resource)
      end

      # GET /resource/confirmation?confirmation_token=abcdef
      def show
        self.resource = resource_class.confirm_by_token(params[:confirmation_token])
        respond_with(resource)
      end
    end
  end
end
