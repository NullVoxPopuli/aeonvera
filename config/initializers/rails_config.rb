# frozen_string_literal: true

Rails.application.config.assets.precompile += %w[email.css]
Rails.application.config.filter_parameters += [:password, :password_confirmation, :current_password]
# Be sure to restart your server when you modify this file.
Rails.application.config.session_store :disabled

# AeonVera::Application.config.session_store :disabled

# Be sure to restart your server when you modify this file.

# This file contains settings for ActionController::ParamsWrapper which
# is enabled by default.

# Enable parameter wrapping for JSON. You can disable this by setting :format to an empty array.
ActiveSupport.on_load(:action_controller) do
  wrap_parameters format: [:json] if respond_to?(:wrap_parameters)
end

# To enable root element in JSON for ActiveRecord objects.
# ActiveSupport.on_load(:active_record) do
#  self.include_root_in_json = true
# end
Mime::Type.register('application/vnd.api+json', :jsonapi)

PARSER = lambda do |body|
  hash = JSON.parse(body)

  hash.with_indifferent_access
end

if ::Rails::VERSION::MAJOR >= 5
  ::ActionDispatch::Request.parameter_parsers[:jsonapi] = PARSER
else
  ::ActionDispatch::ParamsParser::DEFAULT_PARSERS[Mime[:jsonapi]] = PARSER
end

# TODO: be able to render with the jsonapi mimetype
# ActionController::Renderers.add :jsonapi do |json, options|
#   self.content_type ||= Mime[:jsonapi]
#   self.response_body = json
# end
