module OrderOperations
  #
  # This creates an order, and its order line items.
  # This does not charge a credit card. That is what Update is for.
  #
  class Create < SkinnyControllers::Operation::Base
    include Helpers
    include ItemBuilder

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
      host = host_from_params

      # fill out the attendance if it exists
      # this includes setting:
      # - package id
      # - level id
      # - host
      # - attendee / current_user
      # - pricing tier?
      # - needs_housing if housing_request is present (legacy)
      # - providing_housing if housing_provision is present (legacy)
      build_attendance(host)
      build_order(host)
      build_items(params_for_items)
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

    def build_attendance(host)
      if attendance_params.present?
        @attendance = host.attendances.new(
          attendance_params.merge(
            package_id: package_id_from_data,
          )
        )
      end
    end

    def build_order(host)
      # build out the order
      @model = Order.new(
        host: host,
        attendance: @attendance, # nil or will be set
        # a user is alwoys going to be the person paying.
        # if an attendance is passed, use the user from
        # that attendance.
        user: @attendance.try(:attendee) || current_user,
        # TODO: assign attendance
      )

      # the payment token is used for people who aren't logged in.
      # In order to update / pay for an order, you must either
      # be the owner, or have this token in the URL
      @model.payment_token = params[:order][:payment_token] unless @model.user
      @model.buyer_email = params_for_order[:user_email] if params_for_order[:user_email].present?
      @model.buyer_name = params_for_order[:user_name] if params_for_order[:user_name].present?
    end
  end
end
