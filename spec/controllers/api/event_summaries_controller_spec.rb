# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Api::CustomFieldsController, type: :controller do
  before(:each) do
    @event = create(:event)
    login_through_api(@event.hosted_by)
  end

  context 'show' do
    it 'renders' do
      get :show, id: @event.id
    end
  end
end
