class AddPaymentReceivedAtToOrders < ActiveRecord::Migration
  def up
    add_column :orders, :payment_received_at, :datetime

    Order.paid.each do |order|
      if order.payment_method == Payable::Methods::STRIPE
        stripe_time = order.metadata.try(:[], "details").try(:[], "created")
        if stripe_time
          order.payment_received_at = Time.at(stripe_time)
        else
          order.payment_received_at = order.updated_at
        end
      else
        order.payment_received_at = order.updated_at
      end

      order.save_without_timestamping(validate: false)
    end
  end

  def down
    remove_column :orders, :payment_received_at
  end
end
