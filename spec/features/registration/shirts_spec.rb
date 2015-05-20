require 'spec_helper'

describe "Registration" do

  before(:each) do
    login_as_confirmed_user
    Event.destroy_all
    @event = create(:event, hosted_by: @user)
    @opening_tier = @event.opening_tier
    @opening_tier.date = Time.now - 1.day
    @opening_tier.save
    @package = create(:package, event: @event)

  end


  context "shirts" do

    before(:each) do
      # create some shirts
      @shirt1 = create(:shirt, event: @event, name: "T-Shirt")
      @shirt2 = create(:shirt, event: @event, name: "Tank Top")
      @shirt3 = create(:shirt, event: @event, name: "These are actually pants")

      visit @event.url
      # fill out all the stuff we don't care about at the moment
      selects_orientation
      selects_package
      provides_address
    end

    it 'chooses a single shirt' do
      fill_in "attendance_metadata_shirts_#{@shirt1.id}_XS_quantity", with: 1

      submit_form

      expect(page).to have_content(@shirt1.name)
    end

    context 'multiple shirts selected' do

      before(:each) do
        fill_in "attendance_metadata_shirts_#{@shirt1.id}_XS_quantity", with: 2
        fill_in "attendance_metadata_shirts_#{@shirt2.id}_M_quantity", with: 1
        fill_in "attendance_metadata_shirts_#{@shirt2.id}_S_quantity", with: 3

        submit_form
      end

      it 'choose multiple shirts of a couple sizes' do
        expect(page).to have_content("#{@shirt1.name} -  2 x XS")
        expect(page).to have_content("#{@shirt2.name} -  3 x S, 1 x M")
      end

      it 'edits the shirt selection' do
        edit_registration

        fill_in "attendance_metadata_shirts_#{@shirt1.id}_XS_quantity", with: 1
        fill_in "attendance_metadata_shirts_#{@shirt2.id}_M_quantity", with: 2
        fill_in "attendance_metadata_shirts_#{@shirt2.id}_S_quantity", with: 1

        submit_form

        expect(page).to have_content("#{@shirt1.name} -  1 x XS")
        expect(page).to have_content("#{@shirt2.name} -  1 x S, 2 x M")
      end

      it 'removes all shirts' do
        edit_registration

        fill_in "attendance_metadata_shirts_#{@shirt1.id}_XS_quantity", with: 0
        fill_in "attendance_metadata_shirts_#{@shirt2.id}_M_quantity", with: 0
        fill_in "attendance_metadata_shirts_#{@shirt2.id}_S_quantity", with: 0

        submit_form

        expect(page).to_not have_content("#{@shirt1.name}")
        expect(page).to_not have_content("#{@shirt2.name}")
        expect(page).to_not have_content("#{@shirt3.name}")
      end

    end

  end

end
