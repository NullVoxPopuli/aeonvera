module Api
  # object is actually an Attendance in this serializer
  class LineItem::LessonSerializer < LineItemSerializer
    type 'lesson'
  end
end
