# This controller only responds to update
module Api
  class Users::CollaborationsController < APIController
    before_filter :must_be_logged_in

    def update
      render_model
    end

    # model will contain errors if something went wrong
    def model
      @model_result ||= accept_operation.run
    end

    def accept_operation
      @accept_operation ||= CollaborationOperations::AcceptInvitation.new(
        current_user,
        params,
        accept_params)
    end

    private

    def accept_params
      params.permit(:host_type, :host_id, :token)
    end
  end
end
