require "spec_helper"

describe HostedEvents::PassesController do
  describe "routing" do
    before(:each) do
      @event = create(:event)
      @event_path = "hosted_events/#{@event.id}"
    end
    it "routes to #index" do
      get("#{@event_path}/passes").should route_to(*event_path("passes#index"))
    end

    it "routes to #new" do
      get("#{@event_path}/passes/new").should route_to(*event_path("passes#new"))
    end

    it "routes to #show" do
      get("#{@event_path}/passes/1").should route_to(*event_path("passes#show", :id => "1"))
    end

    it "routes to #edit" do
      get("#{@event_path}/passes/1/edit").should route_to(*event_path("passes#edit", :id => "1"))
    end

    it "routes to #create" do
      post("#{@event_path}/passes").should route_to(*event_path("passes#create"))
    end

    it "routes to #update" do
      put("#{@event_path}/passes/1").should route_to(*event_path("passes#update", :id => "1"))
    end

    it "routes to #destroy" do
      delete("#{@event_path}/passes/1").should route_to(*event_path("passes#destroy", :id => "1"))
    end

  end
end
