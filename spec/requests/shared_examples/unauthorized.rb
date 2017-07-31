# frozen_string_literal: true
require 'rails_helper'

shared_examples 'unauthorized' do |options = {}|
  expected_status = options[:status] || 401
  factory_name = options[:factory]
  base_path = options[:base_path]

  context 'index' do
    it 'is denied' do
      get base_path

      expect(response.status).to eq 401
    end
  end

  context 'show' do
    it 'is denied' do
      object = create(factory_name)
      get "#{base_path}/#{object.id}"

      expect(response.status).to eq 401
    end
  end

  context 'create' do
    it 'is denied' do
      post base_path, {}

      expect(response.status).to eq 401
    end
  end

  context 'update' do
    it 'is denied' do
      object = create(factory_name)
      put "#{base_path}/#{object.id}", {}

      expect(response.status).to eq 401
    end
  end

  context 'destroy' do
    it 'is denied' do
      object = create(factory_name)
      delete "#{base_path}/#{object.id}"

      expect(response.status).to eq 401
    end
  end
end
