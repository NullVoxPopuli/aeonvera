module PublicAttributes
  module LevelAttributes
    extend ActiveSupport::Concern

    included do
      attributes :id, :event_id,
        :name,
        :requirement, :deleted_at
    end
  end
end
