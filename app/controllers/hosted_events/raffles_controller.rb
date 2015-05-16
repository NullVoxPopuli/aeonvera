class HostedEvents::RafflesController < ApplicationController
  include SetsEvent
  include LazyCrud

  set_resource Raffle
  set_resource_parent Event
  set_param_whitelist([:name])

  before_action :set_resource, only: [:show, :edit, :update, :destroy, :choose_winner]
  before_action :set_resource_instance, only: [:show, :edit, :update, :destroy, :choose_winner]

  layout "edit_event"
  #
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

end
