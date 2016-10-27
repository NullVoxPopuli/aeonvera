class CustomFieldResponse < ActiveRecord::Base
  include SoftDeletable

  belongs_to :writer, polymorphic: true
  belongs_to :custom_field, -> { with_deleted }

  # TODO: re-enable when moving to ember
  # validates :writer, presence: true
  validates :custom_field, presence: true

  scope :with_values, -> {
    column = CustomFieldResponse.arel_table[:value]
    where(column.not_eq(nil).or(column.not_eq('')))
  }

end
