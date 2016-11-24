module Api
  class ChartDataController < APIController
    include SetsEvent

    def show
      render json: @event, serializer: chart_serializer
    end

    private

    def chart_serializer
      chart_type = params[:chart_type]

      case chart_type
      when 'line-income-and-registrations' then ChartData::IncomeAndRegistrationsChartSerializer
      when 'sunburt-registration-breakdown' then ChartData::RegistrationBreakdownSerializer
      end
    end
  end
end
