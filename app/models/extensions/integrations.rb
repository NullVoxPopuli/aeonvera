# frozen_string_literal: true
# extends the integrations association for {Account}s and {User}s
#   such that integrations becames a psuedo object
module Extensions
  module Integrations
    # pretend that integrations is a hash of kind => integration
    # @param [Symbol | String] kind the name of the integration to find
    def [](kind)
      where('kind = ?', kind.to_s).first
    end

    # overrite or create an existing integration
    # only one instance of a kind of integration
    #
    # If the caller is an event, a new integration with user_id = nil
    #   will be created or written to
    # If the caller is a user, a new integration with user_id = user[:id]
    #   will be created or written to
    #
    # @param [Symbol | String] kind the name of the integration to find
    # @param [Hash] config the configuration to set / create with
    # @return [Hash] config of the saved configuration
    def []=(kind, config)
      integration = self[kind]

      if integration.nil?
        # create  new integration
        parent = proxy_association.owner
        integration = Integration.new(
          owner: parent,
          kind: kind.to_s,
          config: config
        )
      else
        # update
        integration.config = config
      end
      integration.save

      integration.config
    end

    # @param [Symbol / String] kind the name of the integration
    # @return [Boolean] if the integration exists
    def has?(kind)
      !!self[kind]
    end

    # this allows the faux integrations object to retreive the config for
    #   integration, while checking if the integration is nil before calling
    #   .config on it.
    # @return <Hash> Integration config or empty hash
    def method_missing(name, *args, &block)
      # general way to get config for any integration
      return super unless name.to_s =~ /(.+)_config/

      integration_name = Regexp.last_match(1) # the captured result of the regex match
      integration = self[integration_name]

      # default to returning an empty hash if the integration isn't defined
      integration ? integration.config : {}
    end

    def respond_to_missing?(method_name, include_private = false)
      method_name.to_s =~ /(.+)_config/ || super
    end
  end
end
