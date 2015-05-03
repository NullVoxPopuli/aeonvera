require "spec_helper"

describe ApplicationController do

	it "ignores the public www" do
		request.stub(:host_with_port).and_return("www.#{controller.send(:current_domain)}")
		controller.send(:check_subdomain).should be_nil # returns nothing
	end

	context "we are not on the www subdomain" do

		before(:each) do
			request.stub(:host_with_port).and_return(controller.send(:current_domain))
			request.stub_chain(:host_with_port, :include?).and_return(false)
		end

		it "redirects if the controller is the not the register controller" do
			controller.stub(:params).and_return(controller: "hosted_events")
			allow(Subdomain).to receive(:is_event?){ true }
			allow(Subdomain).to receive(:matches?){ true }

			controller.should_receive(:drop_subdomain_and_redirect)
			result = controller.send(:check_subdomain)
		end



	end

end