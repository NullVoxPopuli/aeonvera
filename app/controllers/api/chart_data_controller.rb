class Api::ChartDataController < APIController
  include SetsEvent

  def show
    render json: @event, serializer: IncomeAndRegistrationsChartSerializer
  end
end
