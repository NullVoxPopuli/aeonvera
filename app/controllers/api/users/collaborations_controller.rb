class Api::Users::CollaborationsController < APIController
  before_filter :must_be_logged_in

  def update
    operation = CollaborationOperations::AcceptInvitation.new(
      current_user,
      params,
      accept_params)

    model = operation.run

    # model will contain errors if something went wrong
    render json: model
  end

  private

  def accept_params
    params.permit(:host_type, :host_id, :token)
  end
end
