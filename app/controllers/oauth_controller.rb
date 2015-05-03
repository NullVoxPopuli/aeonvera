class OauthController < ApplicationController
  include EventLoader

  protected

  # produces the access_token
  def identify(response = params)
    response_code = response[:code]
    state = response[:state]

    data = {
      :client_id => client_id,
      :code => response_code,
      :client_secret => client_secret,
      :redirect_uri => "",
      :scope => "read_write",
      :grant_type => "authorization_code"
    }

    uri = URI.parse(access_token_url)
    http = Net::HTTP.new(uri.host, 443)
    http.use_ssl = true
    request = Net::HTTP::Post.new(uri.request_uri)
    request.set_form_data(data)
    response = http.request(request)

    response_body = JSON.parse(response.body)
    if (error = response_body["error"]).present?
      raise error
    end

    return response_body
  end
end
