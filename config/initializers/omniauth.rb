Rails.application.config.middleware.use OmniAuth::Builder do
  require 'omniauth-openid'
  require 'openid/store/filesystem'

  configure do |config|
  	config.path_prefix = "/auth"
  end

  provider :open_id, :name => 'admin',
    :identifier => 'https://www.google.com/accounts/o8/id',
    :store => OpenID::Store::Filesystem.new('/tmp')
end

# Needed for failure callback to work in a development environment.
OmniAuth.config.on_failure = Proc.new { |env|
	OmniAuth::FailureEndpoint.new(env).redirect_to_failure
}
