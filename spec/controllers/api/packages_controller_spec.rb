require 'rails_helper'

RSpec.describe Api::PackagesController, type: :controller do
  before(:each) do
    login_through_api
    @event = create(:event, hosted_by: @user)
  end

  context 'index' do
    it 'does not return unrelated packages' do
      package = create(:package, event: create(:event))
      related = create(:package, event: @event)
      get :index, filter: { id: "#{package.id},#{related.id}" }

      # sanity
      expect(package.event).to_not eq related.event
      expect(@user).to eq @event.user
      expect(@user).to_not eq package.event.user
      expect(package.event.is_accessible_to?(@user)).to_not eq true

      # check the request result
      json = JSON.parse(response.body)
      data = json['data']
      expect(data.size).to eq 1
      expect(data.first['id']).to eq related.id.to_s
    end

    it 'returns an events packages' do
      unrelated = create(:package)
      package = create(:package, event_id: @event.id)
      get :index, event_id: @event.id

      json = JSON.parse(response.body)
      data = json['data']
      expect(data.size).to eq 1
      expect(data.first['id']).to eq package.id.to_s
    end
  end

end
