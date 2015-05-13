class CustomFieldResponse < ActiveRecord::Base
  include SoftDeletable

  belongs_to :writer, polymorphic: true
  belongs_to :custom_field

  validate :writer, presence: true
  validate :custom_field, presence: true

  scope :with_values, -> {
    column = CustomFieldResponse.arel_table[:value]
    where(column.not_eq(nil).or(column.not_eq('')))
  }

end
