require 'spec_helper'


describe 'Registration Custom Fields' do

  before(:each) do
    login_as_confirmed_user
    Event.destroy_all
    @event = create(:event, hosted_by: @user)
    @opening_tier = @event.opening_tier
    @opening_tier.date = Time.now - 1.day
    @opening_tier.save
  end


    context 'custom fields' do
      before(:each) do
        @package = create(:package, event: @event)

        @custom1 = create(:custom_field, host: @event, user: @user)
        @custom2 = create(:custom_field, label: 'value 2', host: @event, user: @user, default_value: '2')
        @custom1_id = "#attendance_custom_field_responses_attributes_0_value"
        @custom2_id = "#attendance_custom_field_responses_attributes_1_value"
        @custom1_name = "attendance[custom_field_responses_attributes][0][value]"
        @custom2_name = "attendance[custom_field_responses_attributes][1][value]"
      end

      it 'renders the custom_fields on the form' do
        visit @event.url
        expect(page).to have_selector(@custom1_id)
        expect(page).to have_selector(@custom2_id)
      end

      it 'fills out the custom_fields, creating CustomFieldResponses' do
        visit @event.url
        selects_orientation
        selects_package
        provides_address

        fill_in @custom1_name, with: "value 1"

        expect{
          submit_form
          expect(page).to_not have_content("error")
        }.to change(CustomFieldResponse, :count).by(2)
      end
    end


end
