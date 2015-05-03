require 'spec_helper'


describe "Cancelled Attendances" do

  before(:each) do
    login_as_confirmed_user
    create(:event, hosted_by: @user)
    
  end
end
