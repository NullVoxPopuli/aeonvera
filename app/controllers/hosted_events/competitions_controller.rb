class HostedEvents::CompetitionsController < ApplicationController
  before_action :set_event
  before_action :set_competition, only: [:show, :edit, :update, :destroy]

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

  # GET /competitions/new
  def new
    @competition = Competition.new
  end

  # GET /competitions/1/edit
  def edit
  end

  # POST /competitions
  # POST /competitions.json
  def create
    @competition = Competition.new(competition_params)

    @competition.event = @event
    respond_to do |format|
      if @competition.save
        format.html { redirect_to hosted_event_competitions_path(@event.id), notice: 'Competition was successfully created.' }
        format.json { render action: 'show', status: :created, location: @competition }
      else
        format.html { render action: 'new' }
        format.json { render json: @competition.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /competitions/1
  # PATCH/PUT /competitions/1.json
  def update
    @competition.event = @event

    respond_to do |format|
      if @competition.update(competition_params)
        format.html { redirect_to hosted_event_competitions_path(@event.id), notice: 'Competition was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @competition.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /competitions/1
  # DELETE /competitions/1.json
  def destroy
    @competition.destroy
    respond_to do |format|
      format.html {
        flash[:notice] = "#{@competition.name} has been deleted."
        redirect_to hosted_event_competitions_path(@event)
      }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.

  def set_competition
    @competition = @event.competitions.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def competition_params
    params[:competition].permit(:name, :initial_price, :at_the_door_price, :kind)
  end
end
