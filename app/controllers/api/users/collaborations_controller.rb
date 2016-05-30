class Api::Users::CollaboratorsController < APIController

  def update
    operation = CollaborationOperations::AcceptInvitation.new(
      current_user,
      params,
      accept_params)

    model = operation.run

    render json: {}, status: ok
  end

  private

  def accept_params
    params.require(:host_type, :host_id, :token)
  end

end
