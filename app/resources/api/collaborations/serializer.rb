module Api
  class CollaborationSerializer < ActiveModel::Serializer
    attributes :id,
      :user_name, :title, :created_at

    belongs_to :host

    def host
      object.collaborated
    end

    def user_name
      object.user&.name
    end
  end
end
