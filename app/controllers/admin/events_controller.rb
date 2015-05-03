class Admin::EventsController < AdminController

	def index
		@events = Event.all
	end

	def toggle_beta
		@event = Event.find(params[:id])
		@event.beta = (not @event.beta)
		@event.save_without_timestamping

		redirect_to admin_events_path
	end
end