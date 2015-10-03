class Api::RegistrationsController < APIController

  def index
    @attendances = current_user.attendances
    render json: @attendances, each_serializer: RegistrationSummarySerializer
  end

  def show
    @attendance = current_user.attendances.find(params[:id])
    render json: @attendance
  end

end
