class Api::VolunteersController < APIController
  include SetsEvent

  def index
    render json: @event.attendances.volunteering, each_serializer: VolunteerSerializer
  end
end
