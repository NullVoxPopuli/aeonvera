# == Schema Information
#
# Table name: discounts
#
#  id                     :integer          not null, primary key
#  name                   :string(255)
#  value                  :decimal(, )
#  kind                   :integer
#  disabled               :boolean          default(FALSE)
#  affects                :string(255)
#  host_id                :integer
#  created_at             :datetime
#  updated_at             :datetime
#  deleted_at             :datetime
#  allowed_number_of_uses :integer
#  host_type              :string(255)
#  discount_type          :string(255)
#  requires_student_id    :boolean          default(FALSE)
#
# Indexes
#
#  index_discounts_on_host_id_and_host_type  (host_id,host_type)
#

require 'spec_helper'

describe Discount do

  context '#code' do
    it 'does not allow & for the code' do
      d = Discount.new(code: "J&J", amount: 5)
      expect(d.valid?).to eq false
      msgs = d.errors.full_messages
      expect(msgs.first).to include("Code")
    end
  end

  context '#times_used' do

    it 'calculates based on orders' do
      e = create(:event)
      d = create(:discount, host: e)
      o = create(:order, host: e, attendance: create(:attendance, host: e))
      create(:order_line_item, line_item: d, order: o)

      expect(d.times_used).to eq 1
    end
  end

end
