require 'spec_helper'


describe Attendance do

  describe '#attendee_name' do
    let(:event){ create(:event) }

    it 'returns the transfer name if set' do
      attendance = create(:attendance, event: event, transferred_to_name: 'Luke')

      expect(attendance.attendee_name).to eq 'Luke'
    end

    it 'returns the name of the user' do
      user = create(:user)
      attendance = create(:attendance, event: event, attendee: user)

      expect(attendance.attendee_name).to eq user.name.titleize
    end
  end

end
