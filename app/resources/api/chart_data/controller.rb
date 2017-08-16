# frozen_string_literal: true

module Api
  class ChartDataController < APIController
    include SetsEvent

    def show
      render_jsonapi(model: presented)
    end

    private

    def presented
      chart_type = params[:chart_type]

      case chart_type
      when 'line-income-and-registrations'
        return ChartDataPresenters::IncomeAndRegistrationsPresenter.new(@event)
      when 'sunburt-registration-breakdown'
        return ChartDataPresenters::RegistrationBreakdownPresenter.new(@event)
      end
    end

    def serializer
      chart_type = params[:chart_type]

      case chart_type
      when 'line-income-and-registrations' then ChartData::IncomeAndRegistrationsChartSerializableResource
      when 'sunburt-registration-breakdown' then ChartData::RegistrationBreakdownSerializableResource
      end
    end
  end
end
