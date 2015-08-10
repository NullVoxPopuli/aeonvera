class LineItem::Shirt < LineItem
  has_many :order_line_items, -> {
    where(line_item_type: LineItem::Shirt.name)
  }, foreign_key: :line_item_id


  ALL_SIZES = ['XS', 'S', 'SM', 'M', 'L', 'XL', 'XXL', 'XXXL']

	def sizes
		self.metadata["sizes"] || []
	end

  def prices
    self.metadata["prices"] || {}
  end

  def price_for_size(size)
    prices[size].presence || price
  end

  # clean version of sizes
  # (no "")
  def offered_sizes
    self.sizes.delete_if{ |s| s.empty? }
  end

	# legacy
	def size; ""; end

end
