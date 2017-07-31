# frozen_string_literal: true
# == Schema Information
#
# Table name: custom_fields
#
#  id            :integer          not null, primary key
#  label         :string(255)
#  kind          :integer
#  default_value :text
#  editable      :boolean          default(TRUE), not null
#  host_id       :integer
#  host_type     :string(255)
#  user_id       :integer
#  deleted_at    :datetime
#  created_at    :datetime
#  updated_at    :datetime
#
# Indexes
#
#  index_custom_fields_on_host_id_and_host_type  (host_id,host_type)
#

class CustomField < ApplicationRecord
  include SoftDeletable

  belongs_to :host, polymorphic: true
  belongs_to :user

  has_many :custom_field_responses

  validates :label, presence: true
  validates :kind, presence: true
  validates :host, presence: true
  validates :user, presence: true

  # TODO: is it worth it to make subclasses for all these
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
