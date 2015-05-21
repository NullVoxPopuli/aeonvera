require 'spec_helper'


describe Attendance do

  describe '#total_cost_for_selected_shirt' do

      let(:event){ create(:event) }
      let(:attendance){ create(:attendance, event: event) }
      let(:shirt){ create(:shirt, event: event) }

      context 'a shirt has different prices for the larger sizes' do

        before(:each) do
          shirt.metadata['prices'] = {
            'XL' => 20
          }
          shirt.save
        end


        it 'has one shirt of unmentioned specific size' do
          attendance.metadata = {
            'shirts' => {
              shirt.id.to_s => { 'M' => {'quantity' => 1} }
            }
          }

          actual = attendance.total_cost_for_selected_shirt(shirt.id)
          expect(actual).to eq 15
        end

        it 'has one shirt of a larger size that costs more' do
          attendance.metadata = {
            'shirts' => {
              shirt.id.to_s => { 'XL' => {'quantity' => 1} }
            }
          }

          actual = attendance.total_cost_for_selected_shirt(shirt.id)
          expect(actual).to eq 20
        end


        it 'has two larger shirts' do
          attendance.metadata = {
            'shirts' => {
              shirt.id.to_s => { 'XL' => {'quantity' => 2} }
            }
          }

          # each shirt costs 20 bucks
          actual = attendance.total_cost_for_selected_shirt(shirt.id)
          expect(actual).to eq 40
        end

      end

  end

end
