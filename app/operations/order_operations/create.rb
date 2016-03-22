module OrderOperations
  #
  # This creates an order, and its order line items.
  # This does not charge a credit card. That is what Update is for.
  #
  class Create < SkinnyControllers::Operation::Base
    include StripeCharge

    def run
      # when is creating an order ever not allowed?
      # - I'm sure the organizers would always be happy to take money
      create!

      model
    end

    def create!
      # for some reason this is a hash trying to be an array (with indicies)
      host_id, host_type = params_for_action.values_at(:host_id, :host_type)
      user_email = params_for_action[:user_email]

      # get the event / organization that this order ties to
      host = host_from(host_id, host_type)

      build_order(host)

      if @model.sub_total > 0
        @model.payment_method = Payable::Methods::STRIPE
      else
        @model.paid = true
        @model.payment_method = Payable::Methods::CASH

        return if @model.errors.present?
        save_order
      end
    end

    def save_order
      ActiveRecord::Base.transaction do
        @model.save
        @model.line_items.map(&:save)
      end
    end

    def build_order(host)
      # build out the order
      @model = Order.new(
        host: host,
        # is a user required?
        # what if the current user isn't the one paying?
        user: current_user,
        # TODO: assign attendance
      )
    end

    def host_from(id, host_type)
      if host_type.downcase.include?('organization')
        Organization.find(id)
      else
        Event.find(id)
      end
    end
  end

end
