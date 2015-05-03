require 'spec_helper'

RSpec.describe "dances/new", :type => :view do
  before(:each) do
    assign(:dance, LineItem::Dance.new())
  end

  it "renders new dance form" do
    pending("example view spec")
    render

    assert_select "form[action=?][method=?]", dances_path, "post" do
    end
  end
end
