class HostedEvents::PackagesController < ApplicationController
	before_action :set_event

	before_action :set_package, only: [:show, :edit, :update, :destroy]

	layout "edit_event"

	# GET /packages
	# GET /packages.json
	def index
		@packages = @event.packages.with_deleted
	end

	# GET /packages/1
	# GET /packages/1.json
	def show
	end

	# GET /packages/new
	def new
		@package = Package.new
	end

	# GET /packages/1/edit
	def edit
	end

	# POST /packages
	# POST /packages.json
	def create
		@package = @event.packages.build(package_params)

		respond_to do |format|
			if @package.save
				format.html { redirect_to hosted_event_packages_path(@event), notice: 'Package was successfully created.' }
				format.json { render action: 'show', status: :created, location: @package }
			else
				format.html { render action: 'new' }
				format.json { render json: @package.errors, status: :unprocessable_entity }
			end
		end
	end

	# PATCH/PUT /packages/1
	# PATCH/PUT /packages/1.json
	def update
		respond_to do |format|
			if @package.update(package_params)
				format.html { redirect_to hosted_event_packages_path(@event), notice: 'Package was successfully updated.' }
				format.json { head :no_content }
			else
				format.html { render action: 'edit' }
				format.json { render json: @package.errors, status: :unprocessable_entity }
			end
		end
	end

	# DELETE /packages/1
	# DELETE /packages/1.json
	def destroy
		@package.destroy
		respond_to do |format|
			format.html { redirect_to hosted_event_packages_path(@event) }
			format.json { head :no_content }
		end
	end

	private
	# Use callbacks to share common setup or constraints between actions.

	def set_package
		@package = @event.packages.find(params[:id])
	end

	# Never trust parameters from the scary internet, only allow the white list through.
	def package_params
		params[:package].permit(
			:name,
			:requires_track,
			:initial_price,
			:at_the_door_price,
			:expires_at,
			:attendee_limit,
			:ignore_pricing_tiers
		)
	end
end
