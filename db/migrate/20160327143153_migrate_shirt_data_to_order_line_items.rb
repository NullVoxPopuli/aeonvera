class MigrateShirtDataToOrderLineItems < ActiveRecord::Migration

  # move shirt data from attendance metadata and from the AttendanceLineItem to the order_line_items
  def up
    OrderLineItem.reset_column_information
    Attendance.all.each do |a|
      # these are existing order_line_items that corespond to shirts
      ordered_shirts = a.ordered_shirts
      # shirt data from metadata
      # {
      #   "ShirtId" => {
      #     "SizeAbbr" => {
      #        "quantity" => "1"
      #     }
      #   }
      # }
      #
      # The entire shirt structure is in here
      # but non-purchased shirts will have quantity as ""
      #
      # I"m so glad I'm migrating this...
      shirt_data = shirt_data(a)
      # line_item_data from metadata
      #
      # {
      #   "lineitemid#" => { "quantity" => "1" }
      # }
      line_item_data = line_item_data(a)

      # NOTE: when there is a shirt_data or line_item_data entry,
      # there is always going to be a corresponding order line item
      # on the order.
      next unless shirt_data || line_item_data

      shirt_data ||= {}
      line_item_data ||= {}

      # because shirt_data and line_item data are
      # both line items, we can combine the two hashes
      # two make searching easier.
      item_datas = shirt_data.merge(line_item_data)

      orders = a.orders
      # hopefully there is only one order in most situations
      orders.each do |order|
        current_total = order.total

        order.order_line_items.each do |order_line_item|
          id = order_line_item.line_item_id
          kind = order_line_item.line_item_type
          total_price = order_line_item.price * order_line_item.quantity

          data_for_item = item_datas[id.to_s]
          # skip if the line item isn't one in the metadata
          next unless data_for_item

          # if the data_for_item does not immediately contain
          # a quantity key, than we are dealing with shirt data
          is_shirt = !data_for_item.keys.include?("quantity")

          # move on if the data is a shirt, but the line item
          # is not a shirt
          next if is_shirt && !kind.include?('Shirt')

          # assign new attributes to the order_line_items
          if is_shirt
            quantity = total_quantity_for_shirt(item_datas, id)

            # Multiple sizes of the same shirt currently only
            # have one line item. This will need to be replaced by multiple
            # line items
            data_for_item.each do |size, size_data|
              item_quantity = size_data['quantity']
              next unless item_quantity.present?
              next unless item_quantity.to_i > 0

              attributes = order_line_item.attributes.select{ |k,v| k != 'id' }
              new_item = order.order_line_items.build(attributes)
              new_item.size = size
              new_item.quantity = size_data['quantity']
              new_item.price = order_line_item.price
              new_item.save_without_timestamping
            end

            order_line_item.destroy

            # make sure totals are the same
            o = Order.find(order.id)
            raise "total mismatch in #{order.id} original: #{current_total} vs new: #{o.total}\n" if current_total != o.total
          else
            quantity = total_quantity_for_line_item(item_datas, id)

            # make sure the quantity matches
            if order_line_item.quantity != quantity && id.to_i != 51
              # it looks like, when this happens, we ignore it, and use the order
              # as the single source of truth
            end
          end


        end
      end
    end
  end

  def down
    # ha
  end

  # helpers - removed from attendance.rb

  def shirt_data(a)
    a.metadata_safe['shirts']
  end

  def line_item_data(a)
    a.metadata_safe['line_items']
  end

  def total_quantity_for_line_item(line_item_data, id)
    total = 0
    item = line_item_data[id.to_s]

    item.try(:[], 'quantity').to_i || 0
  end

  def total_quantity_for_shirt(shirt_data, id)
    shirt = shirt_data[id.to_s]
    if shirt
      total = 0
      shirt.each{|size, data|
        total += data['quantity'].to_i
      }
      return total
    end
    0
  end

  def total_cost_for_selected_shirt(shirt_data, id)
    shirt = shirt_data.try(:[], id.to_s)

    if shirt
      total = 0
      shirt.each{|size, data|
        quantity = data['quantity'].to_i
        current_shirt = event.shirts.select{|s| s.id == id}.first
        total += (quantity * current_shirt.price_for_size(size).to_f)
      }

      return total
    end
    0
  end

end
