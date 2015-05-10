require 'spec_helper'

describe HostedEvents::CustomFieldsController do

  before(:each) do
    login
    @event = create(:event, user: @user)
  end

  describe '#index' do
    it 'sets the collection' do
      get :index, hosted_event_id: @event.id

      expect(assigns(:custom_fields)).to be_present
    end
  end

  describe '#show' do

    it 'gets the custom field' do
      custom_field = create(:custom_field, host: @event, user: @user)
      get :show, hosted_event_id: @event.id, id: custom_field.id

      expect(assigns(:custom_field)).to eq custom_field
    end
  end

  describe '#new' do
    it 'creates an instance of the object' do
      get :new, hosted_event_id: @event.id

      expect(assigns(:custom_field)).to be_new_record
    end
  end

  describe '#edit' do


    it 'sets the instance of the object' do
      custom_field = create(:custom_field, host: @event, user: @user)
      get :edit, hosted_event_id: @event.id, id: custom_field.id
      expect(assigns(:custom_field)).to eq custom_field
    end
  end

  describe '#create' do
    it 'creates and persists a new object' do
      expect{
        post :create, hosted_event_id: @event.id, custom_field: build(:custom_field).attributes
      }.to change(CustomField, :count).by 1

      expect(assigns(:custom_field)).to be_present
    end
  end

  describe '#update' do
    it 'updates and persists changes' do
      custom_field = create(:custom_field, host: @event, user: @user)
      put :update, hosted_event_id: @event.id, id: custom_field.id,
        custom_field: { label: "updated" }

      field = assigns(:custom_field)
      expect(field.label).to eq "updated"
    end
  end


  describe '#destroy' do
    it 'destroys the object' do
      custom_field = create(:custom_field, host: @event, user: @user)

      expect{
        delete :destroy, hosted_event_id: @event.id, id: custom_field.id
      }.to change(@event.custom_fields, :count).by -1

      expect(assigns(:custom_field).deleted_at).to be_present
    end
  end


  describe '#undestroy' do
    it 'un destroys the object' do
      custom_field = create(:custom_field, host: @event, user: @user, deleted_at: Time.now)

      expect{
        post :undestroy, hosted_event_id: @event.id, id: custom_field.id
      }.to change(@event.custom_fields, :count).by 1

      expect(assigns(:custom_field)).to be_present
    end
  end


end
