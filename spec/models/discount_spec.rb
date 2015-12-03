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
      d = create(:discount, event: create(:event))
      create(:order_line_item, line_item: d)

      expect(d.times_used).to eq 1
    end
  end

end
