module StripeMock

  def self.client; @client; end

  def self.start_client(port=4999)
    return false if @state == 'live'
    return @client unless @client.nil?

    alias_stripe_method :request, StripeMock.method(:redirect_to_mock_server)
    @client = StripeMock::Client.new(port)
    @state = 'remote'
    @client
  end

  def self.stop_client(opts={})
    return false unless @state == 'remote'
    @state = 'ready'

    alias_stripe_method :request, @original_request_method
    @client.clear_server_data if opts[:clear_server_data] == true
    @client.cleanup
    @client = nil
    true
  end

  private

  def self.redirect_to_mock_server(method, url, api_key, params={}, headers={}, api_base_url=nil)
    handler = Instance.handler_for_method_url("#{method} #{url}")
    mock_error = client.error_queue.error_for_handler_name(handler[:name])
    if mock_error
      client.error_queue.dequeue
      raise mock_error
    end
    Stripe::Util.symbolize_names client.mock_request(method, url, api_key, params, headers)
  end

end
