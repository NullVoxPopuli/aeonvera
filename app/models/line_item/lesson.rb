class LineItem::Lesson < LineItem
  include Recurrable

  validates :price, presence: true
end
