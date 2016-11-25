# == Schema Information
#
# Table name: orders
#
#  id                          :integer          not null, primary key
#  payment_token               :string(255)
#  payer_id                    :string(255)
#  metadata                    :text
#  attendance_id               :integer
#  host_id                     :integer
#  created_at                  :datetime
#  updated_at                  :datetime
#  paid                        :boolean          default(FALSE), not null
#  payment_method              :string(255)      default("Cash"), not null
#  paid_amount                 :decimal(, )
#  net_amount_received         :decimal(, )      default(0.0), not null
#  total_fee_amount            :decimal(, )      default(0.0), not null
#  user_id                     :integer
#  host_type                   :string(255)
#  payment_received_at         :datetime
#  pricing_tier_id             :integer
#  current_paid_amount         :decimal(, )      default(0.0), not null
#  current_net_amount_received :decimal(, )      default(0.0), not null
#  current_total_fee_amount    :decimal(, )      default(0.0), not null
#  created_by_id               :integer
#
# Indexes
#
#  index_orders_on_created_by_id          (created_by_id)
#  index_orders_on_host_id_and_host_type  (host_id,host_type)
#  index_orders_on_pricing_tier_id        (pricing_tier_id)
#  index_orders_on_user_id                (user_id)
#

class EventOrder < Order

end
