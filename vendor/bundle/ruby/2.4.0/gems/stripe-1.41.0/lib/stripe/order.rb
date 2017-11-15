module Stripe
  class Order < APIResource
    extend Stripe::APIOperations::List
    extend Stripe::APIOperations::Create
    include Stripe::APIOperations::Update

    def pay(params, opts={})
      response, opts = request(:post, pay_url, params, opts)
      initialize_from(response, opts)
    end

    private

    def pay_url
      resource_url + "/pay"
    end

  end
end
