module OrderOperations
  module Helpers

    def order_line_items_params
      params_from_deserialization[:order_line_items_attributes]
    end

    def order_params
      params_from_deserialization
    end

    def package_id_from_data
      order_line_items_params.each do |item|
        if item[:line_item_type] == Package.name
          return item[:line_item_id]
        end
      end
      return nil
    end

    def deserialized_params
      @deserialized_params ||= ActiveModelSerializers::Deserialization.jsonapi_parse(
        params,
        only: [
          # for order
          :attendance, :host, :payment_method,
          :user_email, :user_name,
          # for order_line_items
          :order_line_items,
          :line_item, :price, :quantity,
          :partner_name, :dance_orientation, :size
        ],
        embedded: [
          :order_line_items
        ],
        polymorphic: [:line_item, :host])
    end

    def params_from_deserialization
      @railsified ||= railsify_types(deserialized_params)
    end


    def save_order
      ActiveRecord::Base.transaction do
        @model.save
        @model.line_items.map(&:save)
      end
    end
  end
end
