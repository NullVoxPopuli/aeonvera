module PaypalExpressHelper
  def get_setup_purchase_params(cart, request)
    subtotal, shipping, total = get_totals(cart)
    return to_cents(total), {
      :ip => request.remote_ip,
      :return_url => url_for(:action => 'review', :only_path => false),
      :cancel_return_url => home_url,
      :subtotal => to_cents(subtotal),
      :shipping => to_cents(shipping),
      :handling => 0,
      :tax =>      0,
      :allow_note =>  true,
      :items => get_items(cart),
    }
  end

  def get_shipping(cart)
    # define your own shipping rule based on your cart here
    # this method should return an integer
  end

  def get_items(cart)
    cart.line_items.collect do |line_item|
      product = line_item.product

      {
        :name => product.title,
        :number => product.serial_number,
        :quantity => line_item.quantity,
        :amount => to_cents(product.price),
      }
    end
  end

  def get_totals(cart)
    subtotal = cart.subtotal
    shipping = get_shipping(cart)
    total = subtotal + shipping
    return subtotal, shipping, total
  end

  def to_cents(money)
    (money*100).round
  end
end
