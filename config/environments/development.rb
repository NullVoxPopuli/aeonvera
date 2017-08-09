# frozen_string_literal: true

AeonVera::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Prevent cilcular dependency issue when autoloading changed classes
  config.allow_concurrency = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = false
  config.assets.compile = true
  config.serve_static_files = false

  config.action_mailer.default_url_options = { host: 'swing.vhost:4200' }

  config.action_mailer.perform_deliveries = true

  config.action_mailer.delivery_method = :letter_opener_web

  Mail.defaults do
    delivery_method ActionMailer::Base.delivery_method, ActionMailer::Base.smtp_settings
  end

  config.after_initialize do
  end
end
