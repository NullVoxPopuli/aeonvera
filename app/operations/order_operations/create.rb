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

    # crappy custom JS, cause JSON API doesn't yet have a good way
    # to support creating multiple related records at once. :-(
    def create!
      host_id, host_type = params_for_order.values_at(:hostId, :hostType)

      # get the event / organization that this order ties to
      host = host_from(host_id, host_type)

      build_order(host)
      build_items(params_for_items)

      if @model.sub_total > 0
        @model.payment_method = Payable::Methods::STRIPE
      else
        @model.paid = true
        @model.payment_method = Payable::Methods::CASH
      end

      return if @model.errors.present?

      save_order
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
        # if an attendance is passed, use the user from
        # that attendance.
        # a user is alwoys going to be the person paying.
        user: current_user,
        # TODO: assign attendance
      )

      @model.buyer_email = params_for_order[:userEmail] if params_for_order[:userEmail]
      @model.buyer_name = params_for_order[:userName] if params_for_order[:userName]
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

    def host_from(id, host_type)
      if host_type.downcase.include?('organization')
        Organization.find(id)
      else
        Event.find(id)
      end
    end

    def params_for_order
      @params_for_order ||= params_for_action[:order].dup
    end

    def params_for_items
      @params_for_items ||= params_for_action[:orderLineItems].values
    end
  end

end
