module OrderOperations
  #
  # This creates an order, and its order line items.
  # This does not charge a credit card. That is what Update is for.
  #
  class Create < SkinnyControllers::Operation::Base
    include Helpers

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

      build_order(host)
      build_items(params_for_items)
      assign_default_payment_method

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

    def build_order(host)
      # build out the order
      @model = Order.new(
        host: host,
        # if an attendance is passed, use the user from
        # that attendance.
        # a user is alwoys going to be the person paying.
        user: current_user,
        # TODO: assign attendance
      )

      # the payment token is used for people who aren't logged in.
      # In order to update / pay for an order, you must either
      # be the owner, or have this token in the URL
      @model.payment_token = params[:order][:paymentToken] unless @model.user
      @model.buyer_email = params_for_order[:userEmail] if params_for_order[:userEmail].present?
      @model.buyer_name = params_for_order[:userName] if params_for_order[:userName].present?
    end

    # Each Entry looks like this:
    #
    #   {"quantity"=>"1",
    #  "price"=>"45",
    #  "partnerName"=>"",
    #  "danceOrientation"=>"",
    #  "size"=>"",
    #  "lineItem"=>"123",
    #  "order"=>"",
    #  "lineItemId"=>"123",
    #  "lineItemType"=>"OrderLineItem"}
    #
    # This is just straight from ember
    #
    # @param [Array] params_for_items a list of orderLineItem param entries
    def build_items(params_for_items)
      params_for_items.each do |item_data|
        id = item_data[:lineItemId]
        kind = item_data[:lineItemType]
        if kind != MembershipDiscount.name && kind != Package.name
          kind = kind.include?("LineItem") ? kind : "LineItem::#{kind}"
        end

        item = OrderLineItem.new(
          line_item_id: id,
          line_item_type: kind,
          price: item_data[:price],
          quantity: item_data[:quantity],
          order: @model
        )

        if item.valid?
          @model.line_items << item
        else
          @model.errors.add(:base, item.errors.full_messages.to_s)
        end
      end
    end
  end
end
