class HostedEvents::LineItemsController < ApplicationController
	include SetsEvent

	before_action :set_line_item, only: [:show, :edit, :update, :destroy]

	layout "edit_event"

	# GET /line_items
	# GET /line_items.json
	def index
		@line_items = @event.line_items
	end

	# GET /line_items/1
	# GET /line_items/1.json
	def show
	end

	# GET /line_items/new
	def new
		@line_item = LineItem.new
	end

	# GET /line_items/1/edit
	def edit
	end

	# POST /line_items
	# POST /line_items.json
	def create
		@line_item = @event.line_items.build(line_item_params)

		respond_to do |format|
			if @line_item.save
				format.html { redirect_to hosted_event_line_items_path(@event.id), notice: 'Item was successfully created.' }
				format.json { render action: 'show', status: :created, location: @line_item }
			else
				format.html { render action: 'new' }
				format.json { render json: @line_item.errors, status: :unprocessable_entity }
			end
		end
	end

	# PATCH/PUT /line_items/1
	# PATCH/PUT /line_items/1.json
	def update
		respond_to do |format|
			p = line_item_params
			time = p.delete(:expires_at)
			p[:expires_at] = Time.strptime(time, "%m/%d/%Y %H:%M")
			if @line_item.update(p)
				format.html { redirect_to hosted_event_line_items_path(@event.id), notice: 'Item was successfully updated.' }
				format.json { head :no_content }
			else
				format.html { render action: 'edit' }
				format.json { render json: @line_item.errors, status: :unprocessable_entity }
			end
		end
	end

	# DELETE /line_items/1
	# DELETE /line_items/1.json
	def destroy
		@line_item.destroy
		respond_to do |format|
			format.html { redirect_to hosted_event_line_items_path }
			format.json { head :no_content }
		end
	end

	private
	# Use callbacks to share common setup or constraints between actions.

	def set_line_item
		@line_item = @event.line_items.find(params[:id])
	end

	# Never trust parameters from the scary internet, only allow the white list through.
	def line_item_params
		params[:line_item].permit( :name, :price, :picture, :expires_at)
	end
end