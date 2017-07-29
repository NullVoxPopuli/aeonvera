module Api
  # object is actually an Registration in this serializer
  class LineItem::LessonSerializer < LineItemSerializer
    type 'lesson'
  end

  class LessonSerializer < LineItemSerializer
    type 'lesson'
  end
end
