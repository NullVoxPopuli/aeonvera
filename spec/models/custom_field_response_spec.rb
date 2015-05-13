require 'spec_helper'


describe CustomFieldResponse do

  before(:each) do
    @field = create(:custom_field)
  end

  describe '#custom_field' do
    before(:each) do
      @response = create(:custom_field_response, custom_field: @field)
    end

    it 'returns even if deleted' do
      @field.destroy
      expect(@response.custom_field).to eq @field
      # just in case
      @response.reload
      expect(@response.custom_field).to eq @field
    end

  end
end
