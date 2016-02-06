class Api::OrganizationSummariesController < APIController
  include SetsOrganization

  def show
    render json: @organization,
      serializer: OrganizationSummarySerializer,
      root: :event_summaries,
      include: params[:include]
  end
end
