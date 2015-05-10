class CustomField < ActiveRecord::Base
  include SoftDeletable

  belongs_to :host, polymorphic: true
  belongs_to :user

  has_many :custom_field_responses


  validate :label, presence: true
  validate :kind, presence: true
  validate :host, presence: true
  validate :user, presence: true

end
