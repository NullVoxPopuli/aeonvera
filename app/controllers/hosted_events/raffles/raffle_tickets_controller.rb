class HostedEvents::Raffles::RaffleTicketsController < ApplicationController
  include SetsEvent
  before_action :set_raffle
  before_action :set_raffle_ticket, only: [:show, :edit, :update, :destroy, :choose_winner]


  def index
    @raffle_tickets = @raffle.raffle_tickets.with_deleted
  end

  def new
    @raffle_ticket = @raffle.raffle_tickets.new
  end

  def create
    @raffle_ticket = @raffle.raffle_tickets.build(raffle_ticket_params)

    respond_to do |format|
      if @raffle_ticket.save
        format.html { redirect_to hosted_event_raffle_path(@event, @raffle), notice: 'Raffle was successfully created.' }
        format.json { render action: 'show', status: :created, location: @raffle_ticket }
      else
        format.html { render action: 'new' }
        format.json { render json: @raffle_ticket.errors, status: :unprocessable_entity }
      end
    end
  end

  def show

  end

  def edit

  end

  def update
    respond_to do |format|
      if @raffle_ticket.update(raffle_ticket_params)
        format.html{ redirect_to hosted_event_raffle_path(@event, @raffle), notice: 'Raffle ticket was successfully updated.'}
      else
        format.html{ render action: 'edit'}
      end
    end
  end


  def destroy
    @raffle_ticket.destroy
    respond_to do |format|
      format.html {
        flash[:notice] = "#{@raffle_ticket.name} has been deleted"
        redirect_to hosted_event_raffle_path(@event, @raffle)
      }
      format.json { head :no_content }
    end
  end

  private

  def set_raffle
    @raffle = @event.raffles.find(params[:raffle_id])
  end

  def set_raffle_ticket
    @raffle_ticket = @raffle.raffle_tickets.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def raffle_ticket_params
    params[:line_item_raffle_ticket].permit(:name, :price, metadata: [:number_of_tickets])
  end
end
