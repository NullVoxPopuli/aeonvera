class CustomField < ActiveRecord::Base
  include SoftDeletable

  belongs_to :host, polymorphic: true
  belongs_to :user

  has_many :custom_field_responses

  validate :label, presence: true
  validate :kind, presence: true
  validate :host, presence: true
  validate :user, presence: true

  KIND_TEXT = 0
  KIND_FORMATTED_TEXT = 1
  KIND_NUMBER = 2
  KIND_DATE = 3
  KIND_TIME = 4
  KIND_DATETIME = 5
  KIND_CHECKBOX = 6
  # TODO: How to store options?
  KIND_RADIO = 7
  KIND_RANGE = 8
  KIND_PHONE = 9

end
