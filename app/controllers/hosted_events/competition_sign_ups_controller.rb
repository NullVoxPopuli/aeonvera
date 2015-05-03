class HostedEvents::CompetitionSignUpsController < ApplicationController
  include SetsEvent

  def index

  end

  def new
    @attendances = @event.attendances
  end

  def add_competitions
    @attendance = @event.attendances.find(params[:id])
    @available_competitions = @event.competitions - @attendance.competitions
  end

  def create
    @attendance = @event.attendances.find(params[:id])
    competition = @event.competitions.find(params[:competition_id])


    @attendance.competitions << competition
    @attendance.save

    # create order and mark it paid, for record keeping
    o = Order.new(
      event: @event,
      attendance: @attendance,
      payment_method: Payable::Methods::CASH
    )
    o.add_custom_item(
      price: params[:competition][:amount_paid],
      quantity: 1,
      name: competition.name,
      type: competition.class.name
    )
    o.paid = true
    o.save

    # respond_to do |format|
      if @attendance.valid?
        flash[:notice] = "#{@attendance.attendee_name} is now competing in #{competition.name}"
      else
        flash[:error] = "An error occurred when adding #{@attendance.attendee_name} to #{competition.name}"
      end

      # format.html{
      	redirect_to add_competitions_hosted_event_competition_sign_up_path(@event, id: @attendance)
      # }
    # end
  end
end