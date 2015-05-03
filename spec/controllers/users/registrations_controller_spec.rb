require "spec_helper"

describe Users::RegistrationsController do

  before(:all) do
    @event = create(:event)
  end

  before(:each) do
    login
  end

  describe "#destroy" do
    it "destroys" do
      pending 'Devise has a ton of issues...'
      delete id: @user.id
      user.reload
      user.deleted?.should == true
    end

    it "does not destroy" do
      pending 'Devise has a ton of issues...'
      @user.stub(:upcoming_events).and_return([@event])
      delete :destroy, id: @user.id
      @user.reload
      @user.deleted?.should == false
    end
  end
end
