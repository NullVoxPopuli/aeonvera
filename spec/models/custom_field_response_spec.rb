# == Schema Information
#
# Table name: custom_field_responses
#
#  id              :integer          not null, primary key
#  value           :text
#  writer_id       :integer
#  writer_type     :string(255)
#  custom_field_id :integer          not null
#  deleted_at      :datetime
#  created_at      :datetime
#  updated_at      :datetime
#
# Indexes
#
#  index_custom_field_responses_on_writer_id_and_writer_type  (writer_id,writer_type)
#

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
