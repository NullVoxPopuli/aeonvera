class HostedEvents::RafflesController < ApplicationController
  include SetsEvent
  before_action :set_raffle, only: [:show, :edit, :update, :destroy, :choose_winner]
  layout "edit_event"

  def index
    @raffles = @event.raffles.with_deleted
  end

  def choose_winner
    if @raffle.ticket_holders.count > 0
      @raffle.winner = @raffle.choose_winner
      @raffle.save
    else
      flash[:notice] = "No one has signed up for this raffle yet"
      redirect_to action: 'show'
    end
  end

  def new
    @raffle = @event.raffles.new
  end

  def create
    @raffle = @event.raffles.build(raffle_params)

    respond_to do |format|
      if @raffle.save
        format.html { redirect_to hosted_event_raffles_path(@event), notice: 'Raffle was successfully created.' }
        format.json { render action: 'show', status: :created, location: @raffle }
      else
        format.html { render action: 'new' }
        format.json { render json: @raffle.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
    @raffle_tickets = @raffle.tickets
  end

  def edit

  end

  def update
    respond_to do |format|
      if @raffle.update(raffle_params)
        format.html{ redirect_to hosted_event_raffles_path(@event), notice: 'Raffle was successfully updated.'}
      else
        format.html{ render action: 'edit'}
      end
    end
  end


  def destroy
    @raffle.destroy
    respond_to do |format|
      format.html {
        flash[:notice] = "#{@raffle.name} has been deleted"
        redirect_to hosted_event_raffles_path(@event)
      }
      format.json { head :no_content }
    end
  end

  private

  def set_raffle
    @raffle = @event.raffles.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def raffle_params
    params[:raffle].permit(:name)
  end
end
