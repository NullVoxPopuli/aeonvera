class HostedEvents::DanceOnlyController < ApplicationController
	include SetsEvent

	def new
		@attendance = @event.attendances.new
		@line_items = @event.line_items.active
		@shirts = @event.shirts
	end

	def create
		p = a_la_carte_params
		if p[:line_item_class] == "LineItem::Shirt"
			@line_item = @event.shirts.find(p[:line_item_id])
		else
			@line_item = @event.line_items.find(p[:line_item_id])
		end

		@order = Order.new(event: @event)
		if p[:local][:local_dancer] == "1"
			@order.metadata[:local] = true
		end
		@order.add(@line_item)
		@order.payment_method = p[:order][:payment_method]
		if (n = p[:order][:check_number]).present?
			@order.add_check_number(n)
		end
		@order.paid = true
		o = @order.save

		if o
			flash[:notice] = "#{@line_item.name} successfully recorded"
			redirect_to new_hosted_event_dance_only_path(@event)
		else
			flash[:error] = "There was a problem recording #{@line_item.name}"
			redirect_to action: :new
		end
	end

	private

	def a_la_carte_params
		params[:attendance].permit(
			:line_item_id,
			:line_item_class,
			local: [:local_dancer],
			order: [:payment_method, :check_number]
		)
	end
end
