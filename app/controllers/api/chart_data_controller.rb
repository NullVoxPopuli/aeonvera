module Api
  class ChartDataController < APIController
    include SetsEvent

    def show
      render json: @event, serializer: IncomeAndRegistrationsChartSerializer
    end
  end
end
