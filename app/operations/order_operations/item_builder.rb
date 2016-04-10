module OrderOperations
  module ItemBuilder

    def allowed_to_update?
      # need to check if this token is present in the params
      unloggedin_token = params.try(:[], :order).try(:[], :paymentToken)
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
    def build_items(params_for_items)
      existing_items = params_for_items.select{ |i| i[:id].present? }
      new_items = params_for_items.select{ |i| i[:id].blank? }

      update_items(existing_items)
      create_items(new_items)
    end


    def update_items(items)
      create_or_update(items) do |id, kind, data|
        item = @model.line_items.find(data[:id])
        next unless item

        item.update(
          quantity: data[:quantity],
        )
      end
    end

    def create_items(items)
      create_or_update(items) do |id, kind, data|
        item = OrderLineItem.new(
          line_item_id: id,
          line_item_type: kind,
          price: data[:price],
          quantity: data[:quantity],
          order: @model
        )

        if item.valid?
          @model.line_items << item
        else
          @model.errors.add(:base, item.errors.full_messages.to_s)
        end
      end
    end

    def create_or_update(items, &block)
      items.each do |item_data|
        id = item_data[:lineItemId]
        kind = item_data[:lineItemType]

        non_line_items = [MembershipDiscount.name, Package.name, Competition.name]
        if !non_line_items.include?(kind)
          kind = kind.include?("LineItem") ? kind : "LineItem::#{kind}"
        end

        yield(id, kind, item_data)
      end
    end

  end
end
