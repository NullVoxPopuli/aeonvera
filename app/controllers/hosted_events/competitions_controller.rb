class HostedEvents::CompetitionsController < ApplicationController
  include SetsEvent
  include LazyCrud

  set_resource Competition
  set_resource_parent Event
  set_param_whitelist(
    :name, :initial_price, :at_the_door_price, :kind
  )

  layout "edit_event"

  # GET /competitions
  # GET /competitions.json
  def index
    @competitions = @event.competitions.with_deleted
  end

  def all
    @competitions = @event.competitions
  end

  # GET /competitions/1
  # GET /competitions/1.json
  def show
      respond_to do |format|
        format.html{}
        format.csv{
          send_data @competition.to_competitor_csv
        }
      end
  end

end
