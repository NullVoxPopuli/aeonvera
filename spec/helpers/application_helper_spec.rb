require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the DancesHelper. For example:
#
# describe DancesHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe ApplicationHelper, :type => :helper do

  describe '#event_url_for' do
    it 'generates an url without an action' do
      @event = create(:event)
      competition = create(:competition, event: @event)

      result = helper.event_url_for(competition)

      # should be the show url
      expect(result).to eq "/hosted_events/#{@event.id}/competitions/#{competition.id}"
    end
    it 'generates an url with an action' do
      @event = create(:event)
      competition = create(:competition, event: @event)

      result = helper.event_url_for(competition, action: :edit)

      # should be the edit URL
      expect(result).to eq "/hosted_events/#{@event.id}/competitions/#{competition.id}/edit"
    end
  end
end
