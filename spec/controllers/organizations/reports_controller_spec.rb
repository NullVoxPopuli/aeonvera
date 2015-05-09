require 'spec_helper'


describe Organizations::OrganizationReportsController do

  before(:each) do
    login
    @organization = create(:organization, user: @user)
  end

  describe '#index' do

      context 'CSV Download' do

        it 'does not error with 0 data' do
          expect{
            get :index, organization_id: @organization.id, format: 'csv'
          }.to_not raise_error
        end

        it 'does not error with data' do
          order = create(:order, host: @organization, user: @user)

          expect{
            get :index, organization_id: @organization.id, format: 'csv'
          }.to_not raise_error
        end

      end

  end

end
