class Shirt < LineItem::Shirt
  class << self
    def sti_name
      LineItem::Shirt.name
    end
  end
end
