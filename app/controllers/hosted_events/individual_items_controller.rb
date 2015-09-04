class HostedEvents::IndividualItemsController < ApplicationController
	include SetsEvent

	def new
		return redirect_to action: :index if params[:id].blank?
		@attendance = @event.attendances.find(params[:id])
		@line_items = @event.line_items.active
		@shirts = @event.shirts
	end

	def create
		@attendance = @event.attendances.find(params[:id])
		items = params[:items][:items]
		payment_method = params[:items][:payment_method]
		check_number = params[:items][:check_number]

		order = Order.new(host_id: @event.id, host_type: @event.class.name, attendance_id: @attendance.id)
		order.add_check_number(check_number)
		items.each do |item|
			object = @event.send("#{item[:klass].underscore.pluralize}").find(item[:id])
			@attendance.add(object)
			order.add_custom_item(price: item[:price], quantity: 1, name: object.name, type: object.class.name)
		end
		order.paid = true
		order.payment_method = payment_method
		order.net_amount_received = order.paid_amount = params[:items][:amount_paid]

		order.save

		flash[:notice] = "#{items.size} items added to #{@attendance.attendee_name}'s registration."
		redirect_to hosted_event_attendance_path(@event, @attendance)
	end

	def index
		@attendances = @event.attendances
	end


end
