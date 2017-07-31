# frozen_string_literal: true

require File.expand_path('../boot', __FILE__)

# require 'rails/all'
# omitted: sprockets, rails/test_unit
require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_view/railtie' # for emails :-(
require 'action_mailer/railtie'
require 'active_job/railtie' # for later

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)
require 'csv'

module AeonVera
  class Application < Rails::Application
    # convert all yml files to {file_name}_CONFIG hashes
    Dir["#{Rails.root}/config/*.yml"].each do |file|
      file_name = File.basename(file)
      extension = file_name.split('.').last
      next unless extension == 'yml'
      name = file_name.split('.').first
      next if name.casecmp('DATABASE').zero?
      config_name = "#{name.upcase}_CONFIG"
      config = YAML.load_file(file)
      config = HashWithIndifferentAccess.new.merge(config)
      Kernel.const_set(config_name.to_s, config)
    end

    config.active_job.queue_adapter = :sidekiq

    config.cache_store = :redis_store, ENV['REDIS_URL'] if ENV['REDIS_URL']
    # Upgrading from rails 4.1.x to 4.2.x
    # Currently, Active Record suppresses errors raised within
    # `after_rollback`/`after_commit` callbacks and only print them to the logs.
    # In the next version, these errors will no longer be suppressed.
    # Instead, the errors will propagate normally just like in other
    # Active Record callbacks.
    config.active_record.raise_in_transactional_callbacks = true

    config.action_view.field_error_proc = proc { |html_tag, _instance| html_tag }

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Eastern Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.default_locale = :de
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}').to_s]

    config.autoload_paths += [config.root.join('lib')]
    config.autoload_paths += %W[#{config.root}/app/services]
    config.autoload_paths += %W[#{config.root}/app/core]
    config.autoload_paths += %W[#{config.root}/app/resources/concerns]
    config.autoload_paths += %W[#{config.root}/app/resources/concerns/serialization]
    config.autoload_paths += %W[#{config.root}/app/models/data]

    config.generators do |g|
      g.test_framework :rspec
    end

    config.paperclip_defaults = {
      storage: :s3,
      s3_protocol: :https,
      s3_credentials: {
        bucket: ENV['S3_BUCKET_NAME'] || 'aeonvera-dev',
        # these development s3 credentials do not have access to staging or production buckets
        access_key_id: ENV['S3_ACCESS_KEY_ID'] || 'AKIAI4M3O6VZWG7P5VLQ',
        secret_access_key: ENV['S3_SECRET_ACCESS_KEY'] || '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'
      },
      s3_region: 'us-east-1',
      url: ':s3_domain_url'
    }

    # because we want the registration form to be embeddable, and we need to
    # disable X-Frame-Options restrictions (even for the API).
    # this is a browser-implemented security feature to help
    # mitigate phishing attempts
    config.action_dispatch.default_headers = {
      'X-Frame-Options' => 'ALLOWALL'
    }

    # http://edgeguides.rubyonrails.org/api_app.html#choosing-middleware
    # http://guides.rubyonrails.org/rails_on_rack.html#internal-middleware-stack
    config.middleware.delete 'ActionDispatch::Cookies'
    config.middleware.delete 'ActionDispatch::Session::CookieStore'
    config.middleware.delete 'ActionDispatch::Flash'
    config.middleware.delete 'Rack::Lock'
    config.middleware.delete 'ActionDispatch::Static'

    config.middleware.insert_before 0, 'Rack::Cors' do
      allow do
        origins '*'
        resource '*',
                 headers: :any,
                 methods: [:get, :post, :patch, :delete, :put, :options, :head],
                 credentials: false
      end
    end
  end
end
