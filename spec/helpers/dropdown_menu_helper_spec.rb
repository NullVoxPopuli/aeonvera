require 'spec_helper'


describe DropdownMenuHelper, type: :helper do
  # the methods in this helper depend on
  # eventurl_for from the ApplicationHelper
  include ApplicationHelper

  before(:each) do
    @event = create(:event)
    @competition = create(:competition, event: @event)
  end

  describe '#dropdown_option_menu_for' do
    it 'generatesa foundation dropdown' do

    end
  end

  describe '#dropdown_options' do
    it 'generates a foundation dropdown' do

    end
  end

  describe '#build_dropdown_option_menu_links_for_list' do
    it 'generates a set of links' do
      result = build_dropdown_option_menu_links_list_for(
        @competition, actions: [:edit, :destroy])

      expect(result.length).to eq 2
    end

    it 'attaches the delete method to destroy' do
      result = build_dropdown_option_menu_links_list_for(
        @competition, actions: [:destroy])

      expect(result.first[:options][:method]).to eq :delete
    end
  end

end
