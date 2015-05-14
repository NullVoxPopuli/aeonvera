require 'spec_helper'

describe 'Organization / Scene Registration' do

  before(:each) do
    login_as_confirmed_user
    Organization.destroy_all
    @organization = create(:organization, owner: @user)
    @membership_option = create(:membership_option, organization: @organization)
    @membership_discount = create(
      :membership_discount,
      organization: @organization,
      affects: LineItem::Lesson.name,
      kind: Discount::DOLLARS_OFF,
      value: 10
    )

    @lesson = @organization.lessons.new(price: 45)
    @lesson.save
  end

  it 'sees the manage organization button' do
    pending
    fail
  end

  it 'does not see the manage organization button' do
    pending
    fail
  end

  context 'user is not logged in' do

  end

  context 'register' do
    before(:each) do
      visit @organization.url
      click_link "Register"
    end

    context 'with membership' do
      before(:each) do
        @renewal = create(:membership_renewal,
          membership_option: @membership_option,
          user: @user)

        expect(@user.is_member_of?(@organization)).to eq true
      end

      it 'has discounted the price of lessons' do
        inputs_one_of_each_line_item
        submit_form

        last_order = @organization.orders.last
        expected = @membership_option.price + @lesson.price - @membership_discount.value
        expect(last_order.total).to eq expected
      end
    end

    context 'without membership' do

      it 'has full price of lessons' do
        id = "attendance_line_item_ids_#{@lesson.id}_quantity"
        fill_in id, with: '1'

        submit_form

        last_order = @organization.orders.last
        expected = @lesson.price
        expect(last_order.total).to eq expected
      end
    end

    context 'edits quantities' do

    end

    it 'cancels the registration' do
      registers_for_organization
      click_link "Cancel"
      # 
      # expect{
      #   click_button "I'm sure, cancel registration."
      # }.to change(Attendance.where(attending: true), :count).by(-1)
    end

  end


  context 'thank you email is sent' do
    before(:each) do
      ActionMailer::Base.deliveries.clear

      visit @organization.url
      click_link "Register"

    end


    context 'with membership' do
      before(:each) do
        @renewal = create(:membership_renewal,
          membership_option: @membership_option,
          user: @user)

        expect(@user.is_member_of?(@organization)).to eq true
        inputs_one_of_each_line_item
        submit_form
      end

      it 'generates one email' do
        emails = ActionMailer::Base.deliveries
        expect(emails.count).to eq 1
      end

      it 'email lists one discount' do
        # there was a problem with the discount being shown 3 times
        emails = ActionMailer::Base.deliveries
        email = emails.first
        discount_occurances = email.body.to_s.scan(/#{@membership_discount.name}/).count
        expect(discount_occurances).to eq 1
      end
    end

  end

end
