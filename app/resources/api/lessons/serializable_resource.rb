# frozen_string_literal: true

module Api
  # object is actually an Registration in this serializer
  class LineItem::LessonSerializableResource < LineItemSerializableResource
    type 'lesson'
  end

  class LessonSerializableResource < LineItemSerializableResource
    type 'lesson'
  end
end
