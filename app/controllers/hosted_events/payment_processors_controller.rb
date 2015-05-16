class HostedEvents::PaymentProcessorsController < ApplicationController
  include SetsEvent

  layout "edit_event"

  # authorizable [
  #   index: {
  #     permission: :can_edit_payment_processors?,
  #     target: :event,
  #     redirect_path: hosted_event_path(@event)
  #   }
  # ]

  def index
    @payable = @event
    render file: '/shared/payment_processors/index'
  end

  def create

  end

  def destroy

  end
end
