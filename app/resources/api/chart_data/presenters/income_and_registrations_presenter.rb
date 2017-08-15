# frozen_string_literal: true

module Api
  module ChartDataPresenters
    class IncomeAndRegistrationsPresenter < ApplicationPresenter
      def incomes
        data[:incomes]
      end

      def registrations
        data[:registrations]
      end

      def income_times
        data[:income_times]
      end

      def registration_times
        data[:registration_times]
      end

      private

      def data
        return @data if @data

        registration_times = []
        registrations = []
        income_times = []
        income = []

        count = 0
        money = 0

        registrations = object.registrations.reorder('created_at ASC')
        registrations.each do |registration|
          time = registration.created_at.to_i
          registration_times << time.to_s
          registrations << (count += 1).to_s
        end

        orders = object.orders.reorder('created_at ASC')
        orders.each do |order|
          time = order.created_at.to_i
          income_times << time.to_s
          income << (money += (order.net_amount_received || 0)).round(2)
        end

        if (i_last = income_times.last) != (r_last = registration_times.last)
          if i_last > r_last
            registration_times << i_last
            registrations << registrations.last
          else
            income_times << r_last
            income << income.last
          end
        end

        @data = {
          incomes: income,
          registrations: registrations,
          income_times: income_times,
          registration_times: registration_times
        }
      end
    end
  end
end
