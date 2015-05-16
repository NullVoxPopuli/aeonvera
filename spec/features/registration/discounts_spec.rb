require 'spec_helper'


describe 'Registration Discounts' do

  before(:each) do
    login_as_confirmed_user
    Event.destroy_all
    @event = create(:event, hosted_by: @user)
    @opening_tier = @event.opening_tier
    @opening_tier.date = Time.now - 1.day
    @opening_tier.save
  end

  # have testevent.test.local.vhost
  # in /etc/hosts
  context 'discounts', js: true do
    before(:each) do
      registers_for_event

      @order = @user.attendances.last.orders.last
    end

    it 'discount is allowed to be used 0 times' do
      @discount.allowed_number_of_uses = 0
      @discount.save

      fill_in "discount", with: @discount.name
      click_anchor "#discount_for_#{@order.id}"
      expect(page).to_not have_content(@discount.name)
    end

    it 'discount is allowed to be used 1 time' do
      @discount.allowed_number_of_uses = 1
      @discount.save

      fill_in "discount", with: @discount.name
      click_anchor "#discount_for_#{@order.id}"
      expect(page).to have_content(@discount.name)
    end

    it 'applies a discount with a special (URL) characters' do
      @discount.code = "J?J%J"
      @discount.save

      fill_in "discount", with: @discount.name
      click_anchor "#discount_for_#{@order.id}"
      expect(page).to have_content(@discount.name)

    end

    it 'applies a discount' do
      fill_in "discount", with: @discount.name
      within ".discount-container" do
        click_anchor ".button"
      end
      expect(page).to have_content(@discount.name)
    end

    it 'cannot find the discount code' do
      fill_in "discount", with: "exists?"
      within ".discount-container" do
        click_anchor ".button"
      end
      expect(page).to_not have_content("exists?")
    end
  end


end
