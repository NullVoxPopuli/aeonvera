class CustomFieldSerializer < ActiveModel::Serializer

  attributes :id,
    :host_id, :host_type,
    :label, :kind, :default_value, :editable

    belongs_to :user

end
