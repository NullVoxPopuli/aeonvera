class AttendedEventsController < ApplicationController
	before_action :set_event, only: [:show, :edit, :update, :destroy]

	helper_method :current_event

	# GET /events
	# GET /events.json
	def index
		@attendances = current_user.event_attendances
		render layout: "application"
	end

	# GET /events/1
	# GET /events/1.json
	def show
		#@event_decorator = @event.decorate
		@attendance = current_user.attendance_for_event(@event)
	end

	private

	def current_event
		@event
	end

	# Use callbacks to share common setup or constraints between actions.
	def set_event
		begin
			@event = current_user.hosted_events.find(params[:id])
		rescue ActiveRecord::RecordNotFound => e
			redirect_to action: "index"
		end
	end

	# Never trust parameters from the scary internet, only allow the white list through.
	def event_params
		params[:event].permit(
			:name, :short_description, :starts_at, :ends_at,
			:mail_payments_end_at, :electronic_payments_end_at,
			:refunds_end_at,
			:has_volenteers,
			:housing_status, :housing_nights
		)
	end
end
