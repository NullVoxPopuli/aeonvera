module OrderOperations
  #
  # This creates an order, and its order line items.
  # This does not charge a credit card. That is what Update is for.
  #
  class Create < SkinnyControllers::Operation::Base
    include HelperOperations::Helpers

    def run
      # when is creating an order ever not allowed?
      # - I'm sure the organizers would always be happy to take money
      build_order

      # TODO: verify all the bits are a part of the host
      # - can't sign up for a package that is on another event
      @model.save

      after_save

      model
    end

    private

    def build_order(host = @host)
      # extract non-column-backed data before creating the Order
      user_name = params_for_action.delete(:user_name)
      user_email = params_for_action.delete(:user_email)

      # build out the order
      # this will also build out the order_line_items, thanks
      # to accepts_nested_attributes_for
      @model = Order.new(params_for_action)

      # nil or will be set
      # TODO: do we need to mess with this manually?
      # the new(params_for_action) already cover this
      @model.attendance = attendance

      # a user is alwoys going to be the person paying.
      # if an attendance is passed, use the user from
      # that attendance.
      @model.user = attendance.try(:attendee)
      @model.user = current_user if @model.host.is_a?(Organization)
      @model.created_by = current_user

      # the payment token is used for people who aren't logged in.
      # In order to update / pay for an order, you must either
      # be the owner, or have this token in the URL
      @model.payment_token = params_for_action[:payment_token] unless @model.user
      @model.buyer_email = user_email if user_email.present?
      @model.buyer_name = user_name if user_name.present?

      assign_default_payment_method
    end

    # should this be moved to some sort of business logic one-off layer?
    # 'service'? though, service is a horrible name.
    # is there really enough logic for that abstraction though?
    # it just s eems weird to have membership renewal creating logic
    # coupled with order creation
    def after_save
      return unless current_user && current_user == @model.user

      # if the order's lineitems contain a membership option,
      # create a renewal
      olis = @model.order_line_items.select { |oli| oli.line_item_type == LineItem::MembershipOption.name }

      # hopefully there is only one of these
      olis.each do |order_line_item|
        item = order_line_item.line_item
        MembershipRenewal.new(
          user: current_user,
          membership_option: item,
          start_date: @model.created_at
        ).save!
      end
    end

    # Set payment method based on sub_total.
    # If the subtotal is 0, then we don't care to collect payment.
    def assign_default_payment_method
      if @model.sub_total > 0
        @model.payment_method = Payable::Methods::STRIPE
      else
        @model.paid = true
        @model.payment_method = Payable::Methods::CASH
      end
    end

    def attendance
      @attendance ||= if id = params_for_action[:attendance_id]
        host.attendances.find(id)
      end
    end

    def host
      @host ||= host_from_params(params_for_action)
    end
  end
end
