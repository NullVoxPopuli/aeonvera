require 'jimson-temp'

module StripeMock

  class Server
    extend Jimson::Handler

    def self.start_new(opts)
      puts "Starting StripeMock server on port #{opts[:port] || 4999}"
      server = Jimson::Server.new(Server.new,
        :host => opts[:host] || '0.0.0.0',
        :port => opts[:port] || 4999,
        :server => opts[:server] || :thin,
        :show_errors => true
      )
      server.start
    end

    def initialize
      self.clear_data
    end

    def mock_request(*args)
      begin
        @instance.mock_request(*args)
      rescue Stripe::InvalidRequestError => e
        {
          :error_raised => 'invalid_request',
          :error_params => [e.message, e.param, e.http_status, e.http_body, e.json_body]
        }
      end
    end

    def get_data(key)
      @instance.send(key)
    end

    def destroy_resource(type, id)
      @instance.send(type).delete(id)
    end

    def clear_data
      @instance = Instance.new
    end

    def set_debug(toggle)
      @instance.debug = toggle
    end

    def set_global_id_prefix(value)
      StripeMock.global_id_prefix = value
    end

    def global_id_prefix
      StripeMock.global_id_prefix
    end

    def generate_card_token(card_params)
      @instance.generate_card_token(card_params)
    end

    def generate_bank_token(recipient_params)
      @instance.generate_bank_token(recipient_params)
    end

    def generate_webhook_event(event_data)
      @instance.generate_webhook_event(event_data)
    end

    def debug?; @instance.debug; end
    def ping; true; end
  end

end
