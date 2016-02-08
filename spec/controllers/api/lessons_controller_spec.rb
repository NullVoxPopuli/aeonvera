require 'rails_helper'

RSpec.describe Api::LessonsController, type: :controller do
  context 'index' do
    before(:each) do
      @organization = create(:organization)
      create(:lesson)
    end

    it 'uses the lessons Serializer' do
      get :index, organization_id: @organization.id
      expect(controller).to use_serializer(LineItem::LessonSerializer)
    end

  end
end
