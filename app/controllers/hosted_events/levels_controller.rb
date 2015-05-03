class HostedEvents::LevelsController < ApplicationController
	before_action :set_event
	before_action :set_level, only: [:show, :edit, :update, :destroy]

	layout "edit_event"

	# GET /levels
	# GET /levels.json
	def index

		@levels = @event.levels.with_deleted
	end

	# GET /levels/1
	# GET /levels/1.json
	def show
	end

	# GET /levels/new
	def new
		@level = Level.new
	end

	# GET /levels/1/edit
	def edit
	end

	# POST /levels
	# POST /levels.json
	def create
		@level = @event.levels.build(level_params)

		respond_to do |format|
			if @level.save
				format.html { redirect_to hosted_event_levels_path(@event.id), notice: 'Level was successfully created.' }
				format.json { render action: 'show', status: :created, location: @level }
			else
				format.html { render action: 'new' }
				format.json { render json: @level.errors, status: :unprocessable_entity }
			end
		end
	end

	# PATCH/PUT /levels/1
	# PATCH/PUT /levels/1.json
	def update
		respond_to do |format|
			if @level.update(level_params)
				format.html { redirect_to hosted_event_levels_path(@event.id), notice: 'Level was successfully updated.' }
				format.json { head :no_content }
			else
				format.html { render action: 'edit' }
				format.json { render json: @level.errors, status: :unprocessable_entity }
			end
		end
	end

	# DELETE /levels/1
	# DELETE /levels/1.json
	def destroy
		@level.destroy
		respond_to do |format|
			format.html {
			  flash[:notice] = "#{@level.name} has been deleted"
			  redirect_to hosted_event_levels_url(@event)
			}
			format.json { head :no_content }
		end
	end

	private
	# Use callbacks to share common setup or constraints between actions.

	def set_level
		@level = @event.levels.find(params[:id])
	end

	# Never trust parameters from the scary internet, only allow the white list through.
	def level_params
		params[:level].permit( :name, :requirement, :sequence)
	end
end
