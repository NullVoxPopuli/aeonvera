module SharedAttributes
  module Stock
    extend ActiveSupport::Concern

    included do
      attributes :initial_stock, :remaining_stock, :number_purchased
    end

    def remaining_stock
      object.initial_stock - number_purchased
    end

    def number_purchased
      @number_purchased ||= object.order_line_items.count
    end
  end
end
