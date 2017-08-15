# frozen_string_literal: true

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

class CustomFieldResponse < ApplicationRecord
  include SoftDeletable

  belongs_to :writer, polymorphic: true
  belongs_to :custom_field, -> { with_deleted }

  # TODO: re-enable when moving to ember
  # validates :writer, presence: true
  validates :custom_field, presence: true

  scope :with_values, lambda {
    column = CustomFieldResponse.arel_table[:value]
    where(column.not_eq(nil).or(column.not_eq('')))
  }
end
