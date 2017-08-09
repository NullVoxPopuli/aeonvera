# frozen_string_literal: true

module Api
  module IntegrationOperations
    # TODO: Refactor to handle multiple oauth providers
    class Create < SkinnyControllers::Operation::Base
      def run
        build_integration
        # calling allowed is dependent on the @model existing
        return unless allowed?
        @model.save
        @model
      end

      private

      def build_integration
        authorization_code = model_params.delete(:authorization_code)

        # model_params should contain
        # - name
        # - owner_id, owner_type
        @model = model_class.new(model_params)

        unless authorization_code
          @model.errors.add(:base, 'No Authorization Code Provided')
        end

        stripe_credentials = get_stripe_credentials(authorization_code)

        @model.config = stripe_credentials if @model.errors.blank?

        @model
      end

      def get_stripe_credentials(authorization_code)
        client_id = ENV['STRIPE_CLIENT_ID'] || STRIPE_CONFIG['client_id']
        secret_key = ENV['STRIPE_SECRET_KEY'] || STRIPE_CONFIG['secret_key']
        access_token_url = STRIPE_CONFIG['access_token_url']

        data = {
          client_id: client_id,
          client_secret: secret_key,
          code: authorization_code,
          redirect_uri: '',
          scope: 'read_write',
          grant_type: 'authorization_code'
        }

        uri = URI.parse(access_token_url)
        http = Net::HTTP.new(uri.host, 443)
        http.use_ssl = true
        request = Net::HTTP::Post.new(uri.request_uri)
        request.set_form_data(data)
        response = http.request(request)

        response_body = JSON.parse(response.body)
        if (error = response_body['error']).present?
          @model.errors.add(:base, error)
        end

        response_body
      end
    end
  end
end
