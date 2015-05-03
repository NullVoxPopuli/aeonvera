class LineItem::Shirt < LineItem

  ALL_SIZES = ['XS', 'S', 'SM', 'M', 'L', 'XL', 'XXL', 'XXXL']

	def sizes
		self.metadata["sizes"] || []
	end

  # clean version of sizes
  # (no "")
  def offered_sizes
    self.sizes.delete_if{ |s| s.empty? }
  end

	# legacy
	def size; ""; end

end