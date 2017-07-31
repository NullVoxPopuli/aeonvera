# frozen_string_literal: true
module Api
  class CustomFieldResponseSerializer < ActiveModel::Serializer
    attributes :id, :value

    belongs_to :writer
    belongs_to :custom_field
  end
end
