module OrderOperations
  #
  # This creates an order, and its order line items.
  # This does not charge a credit card. That is what Update is for.
  #
  class Create < SkinnyControllers::Operation::Base
    include Helpers
    include ItemBuilder
    include HelperOperations::Helpers

    def run
      # when is creating an order ever not allowed?
      # - I'm sure the organizers would always be happy to take money
      create!

      model
    end

    # crappy custom JS, cause JSON API doesn't yet have a good way
    # to support creating multiple related records at once. :-(
    def create!
      # get the event / organization that this order ties to
      @host = host_from_params(params_from_deserialization)
      build_order
      build_items(order_line_items_params)
      assign_default_payment_method

      # TODO: verify all the bits are a part of the host
      # - can't sign up for a package that is on another event

      # save the order.
      # this should create:
      # - order
      # - order line items
      # - attendance
      # - custom responses
      # - housing request
      # - housing provision
      save_order unless @model.errors.present?
    end

    def assign_default_payment_method
      if @model.sub_total > 0
        @model.payment_method = Payable::Methods::STRIPE
      else
        @model.paid = true
        @model.payment_method = Payable::Methods::CASH
      end
    end

    def build_order(host = @host)
      # build out the order
      @model = Order.new(
        host: host,
        attendance: attendance, # nil or will be set
        # a user is alwoys going to be the person paying.
        # if an attendance is passed, use the user from
        # that attendance.
        user: attendance.try(:attendee) || current_user,
        # TODO: assign attendance
      )

      # the payment token is used for people who aren't logged in.
      # In order to update / pay for an order, you must either
      # be the owner, or have this token in the URL
      @model.payment_token = params[:order][:payment_token] unless @model.user
      @model.buyer_email = order_params[:user_email] if order_params[:user_email].present?
      @model.buyer_name = order_params[:user_name] if order_params[:user_name].present?
    end

    def attendance
      @attendance ||= if id = order_params[:attendance_id]
        @host.attendances.find(id)
      end
    end
  end
end
