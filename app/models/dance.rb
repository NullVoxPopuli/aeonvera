class Dance < LineItem::Dance
  class << self
    def sti_name
      LineItem::Dance.name
    end
  end
end
