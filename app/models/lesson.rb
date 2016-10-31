class Lesson < LineItem::Lesson
  class << self
    def sti_name
      LineItem::Lesson.name
    end
  end
end
