# frozen_string_literal: true

AeonVera::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = true

  # Eager load code on boot. This eager loads most of Rails and
  # your application in memory, allowing both thread web servers
  # and those relying on copy on write to perform better.
  # Rake tasks automatically ignore this option for performance.
  config.eager_load = true

  # Show full error reports and caching turned on.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = true

  # Disable Rails's static asset server (Apache or nginx will already do this).
  config.serve_static_files = true # allow for ember

  # Compress JavaScripts and CSS.
  config.assets.js_compressor = :uglifier
  # config.assets.css_compressor = :sass

  # Do not fallback to assets pipeline if a precompiled asset is missed.
  config.assets.compile = true

  # Generate digests for assets URLs.
  config.assets.digest = true

  # Version of your assets, change this if you want to expire all your assets.
  config.assets.version = '1.0'

  # Precompile additional assets.
  # application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
  # config.assets.precompile += %w( search.js )
  config.assets.precompile += %w(email.css)

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found).
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners.
  config.active_support.deprecation = :notify

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = true

  # Raise an error on page load if there are pending migrations
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  # config.assets.debug = true

  config.log_level = :debug
  config.logger = Logger.new(STDOUT)

  config.action_mailer.default_url_options = { host: 'aeonvera-staging.work' }

  config.roadie.provider = Roadie::FilesystemProvider.new('/assets', Rails.root.join('public', 'assets'))

  ActionMailer::Base.smtp_settings = {
    port: '587',
    address: 'smtp.sparkpostmail.com',
    user_name: ENV['SPARKPOST_USERNAME'],
    password: ENV['SPARKPOST_PASSWORD'],
    domain: 'aeonvera-staging.work',
    authentication: :plain
  }
  ActionMailer::Base.delivery_method = :smtp

  config.after_initialize do
    BetterErrors::Middleware.allow_ip! ENV['TRUSTED_IP'] if ENV['TRUSTED_IP']
  end
end
