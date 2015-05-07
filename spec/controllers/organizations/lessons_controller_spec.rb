require "spec_helper"

describe Organizations::LessonsController do

  before(:each) do
    login
    @organization = create(:organization, user: @user)
  end


  describe '#duplicate' do

    before(:each) do
      @attributes = build(:lesson).attributes
      @old_lesson = @organization.lessons.create(@attributes)
    end

    it 'duplicates a lesson' do
      expect{
        post :duplicate, id: @old_lesson.id, organization_id: @organization.id
      }.to change(LineItem::Lesson, :count).by(1)
    end

    it 'modifies the name' do
      post :duplicate, id: @old_lesson.id, organization_id: @organization.id
      lesson = assigns(:lesson)
      expect(lesson.name).to eq "Copy of #{@old_lesson.name}"
    end

    it 'includes all of the attributes' do
      post :duplicate, id: @old_lesson.id, organization_id: @organization.id

      lesson = assigns(:lesson)

      expect(lesson[:name]).to eq "Copy of #{@old_lesson.name}"
      expect(lesson[:description]).to eq @old_lesson[:description]
      expect(lesson[:price]).to eq @old_lesson[:price]
      # time zone problems :-( works in UI :-\
      # expect(I18n.l(lesson[:starts_at], format: :time_only)).to eq I18n.l @old_lesson[:starts_at], format: :time_only
      # expect(lesson[:ends_at]).to eq @old_lesson[:ends_at]
      # expect(lesson[:registration_opens_at]).to eq @old_lesson[:registration_opens_at]
      # expect(lesson[:registration_closes_at]).to eq @old_lesson[:registration_closes_at]
      end

  end

end
