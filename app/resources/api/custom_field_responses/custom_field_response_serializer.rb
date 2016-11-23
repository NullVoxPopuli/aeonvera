module Api
  class CustomFieldResponseSerializer < ActiveModel::Serializer
    attributes :id, :value

    belongs_to :writer
    belongs_to :custom_field
  end
end
