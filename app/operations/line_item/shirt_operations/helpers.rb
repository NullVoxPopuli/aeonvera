module LineItem::ShirtOperations
  module Helpers
    # sizes comes in looking like:
    # [ { size: 'M', price: 20 }, { size: 'L', price: 22 } ]
    #
    # sizes (from looong ago, were stored in metadata)
    #
    # shirt.metadata =>
    # :metadata => {
    #   "sizes" => [
    #     [0] "XXL",
    #     [1] "XXXL",
    #     [2] "M",
    #     [3] "S",
    #   ],
    #   "prices" => {
    #     "XXL" => "20",
    #     "XXXL" => "20"
    #   }
    #
    # it was previously assumed that under prices,
    # all sizes had to exist, and if the value was blank, the default price
    # was used. Now, default pricing is handled on the front-end, so
    # prices can only contain what is being sold.
    # This also makes the sizes array useless. But we'll keep it for now,
    # to be compatible with legacy data.
    def params_with_proper_sizing_metadata(whitelisted = model_params)
      # have to delete, because sizes isn't an attribute on Shirt
      sizes = whitelisted.delete(:sizes)
      return unless sizes

      result_sizes = []
      result_prices = {}

      sizes.each do |size_data|
        # skip incomplete entries (this shouldn't happen, though)
        next unless size_data['price'] && size_data['size']

        result_sizes << size_data['size']
        # this will also inadvertantly take care of duplicates
        result_prices[size_data['size']] = size_data['price'].to_s
      end

      # set up new structures in metadata
      whitelisted[:metadata] ||= {}
      whitelisted[:metadata]['sizes'] = result_sizes
      whitelisted[:metadata]['prices'] = result_prices

      whitelisted
    end
  end
end
