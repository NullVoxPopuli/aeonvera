class IncomeAndRegistrationsChartSerializer < ActiveModel::Serializer
  type 'charts'

  attributes :id,
    :incomes, :registrations,
    :income_times,
    :registration_times

  def id
    'income-and-registrations'
  end

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
    unless @data
      registration_times = []
      registrations = []
      income_times = []
      income = []

      count = 0
      money = 0

      attendances = object.attendances.reorder("created_at ASC")
      attendances.each do |attendance|
        time = attendance.created_at.to_i
        registration_times << time.to_s
        registrations << (count += 1).to_s
      end

      orders = object.orders.reorder("created_at ASC")
      orders.each do |order|
        time = order.created_at.to_i
        income_times << time.to_s
        income << (money += (order.net_amount_received || 0)).round(2)
      end

      @data = {
        incomes: income,
        registrations: registrations,
        income_times: income_times,
        registration_times: registration_times
      }
    end

    @data
  end


end
