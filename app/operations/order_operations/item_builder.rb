module OrderOperations
  module ItemBuilder

    def allowed_to_update?
      # need to check if this token is present in the params
      unloggedin_token = params_for_action[:payment_token]
      actual_token = model.payment_token

      allowed? || unloggedin_token == actual_token
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
    def build_items
      params_for_items = params_for_action[:order_line_items_attributes]
      existing_items = params_for_items.select{ |i| i[:id].present? }
      new_items = params_for_items.select{ |i| i[:id].blank? }

      update_items(existing_items)
      create_items(new_items)
    end


    def update_items(items)
      create_or_update(items) do |id, kind, data|
        # we have to use select here so that the item and the order can
        # maintain their association to eachother in-memory.
        # any validation errors the item will be propagated to the order.
        item = model.order_line_items.select{|li|data[:id] == li.id}.first
        next unless item

        item.assign_attributes(
          quantity:          data[:quantity],
          partner_name:      data[:partner_name],
          dance_orientation: data[:dance_orientation],
          size:              data[:size]
        )
      end
    end

    def create_items(items)
      binding.pry
      create_or_update(items) do |id, kind, data|
        item = OrderLineItem.new(
          line_item_id:      id,
          line_item_type:    kind,
          price:             data[:price],
          quantity:          data[:quantity],
          partner_name:      data[:partner_name],
          dance_orientation: data[:dance_orientation],
          size:              data[:size],
          order:             model
        )

        if item.valid?
          model.order_line_items << item
        else
          model.errors.add(:base, item.errors.full_messages.to_s)
        end
      end
    end

    def create_or_update(items, &block)
      items.each do |item_data|
        id = item_data[:line_item_id]
        kind = item_data[:line_item_type]

        kind = EmberTypeInflector.ember_type_to_rails(kind)

        yield(id, kind, item_data)
      end
    end

  end
end
