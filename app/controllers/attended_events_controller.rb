class AttendedEventsController < ApplicationController
	include SetsEvent
	skip_before_action :set_event, only: [:index]

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

end
