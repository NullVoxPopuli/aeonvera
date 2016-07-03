class AddCurrentColumnsToOrderForAggregation < ActiveRecord::Migration
  def change
    change_table 'orders' do |t|
      t.decimal 'current_paid_amount', default: 0.0, null: false
      t.decimal 'current_net_amount_received', default: 0.0, null: false
      t.decimal 'current_total_fee_amount', default: 0.0, null: false
    end

    Order.connection.schema_cache.clear!
    Order.reset_column_information

    if Order.column_names.include?('current_paid_amount')
      Order.all.each do |order|
        order.current_paid_amount = order.paid_amount || 0
        order.current_total_fee_amount = order.total_fee_amount || 0
        order.current_net_amount_received = order.net_amount_received || 0
        order.save_without_timestamping
      end
    end
  end
end
