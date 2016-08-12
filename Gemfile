source 'https://rubygems.org'

ruby '2.3.0'

##########
# Core
##########

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 4.2'
gem 'i18n'
# Use Active Record to store sessions
gem 'activerecord-session_store'
# for cross-origin resource sharing
gem 'rack-cors', :require => 'rack/cors'
# JSON serialization
# gem "active_model_serializers", github: "rails-api/active_model_serializers"
# gem "active_model_serializers", github: "rails-api/active_model_serializers", tag: 'v0.10.0.rc4'
gem "active_model_serializers", git: "https://github.com/NullVoxPopuli/active_model_serializers.git", branch: 'fields-also-whitelists-relationships'
# gem 'active_model_serializers', path: '/home/lprestonsegoiii/Development/active_model_serializers'
# Rediculousness for deserializing embedded data
# gem 'jsonapi_parser', '~>0.5'
gem 'oj'
gem 'oj_mimic_json'

# controllers, chill out!
gem 'skinny_controllers'#, path: '/home/lprestonsegoiii/Development/skinny_controllers'
# gem 'skinny_controllers', path: '/media/Ubuntu-Data/Development/skinny_controllers'

# model helpers
gem 'date_time_attribute'
gem 'recurring_select'
# controller helpers
gem 'lazy_crud'
# request response helpers
gem 'responders'

# automatic includes on everything (AR)
gem 'goldiloader'

group :production do
  # error capturing
  gem 'rollbar'
end

# app performance monitoring
gem "newrelic_rpm"

# database
gem 'pg'
# column encryption
gem "attr_encrypted"

# Cache
gem "redis"
gem "api_cache", github: "NullVoxPopuli/api_cache"

# User Authentication and management
gem "devise"

# soft deletion
gem "paranoia", "~> 2.0"

# email
gem "mail"
# enables rails' layouts for emails
gem "roadie"

# search
gem 'ransack'

# PayPal REST API
# https://github.com/paypal/active_merchant/wiki/PayPal-Rest-Gateway
gem 'paypal-sdk-rest', github: "paypal/rest-api-sdk-ruby"

# validation
gem "date_validator"

# Stripe Payment Processing
gem 'stripe'

# Uploads
gem "paperclip", "~> 5.0.0.beta2"
# Upload Storage on S3
gem 'aws-sdk'#, '< 2.0'


############
# JS, CSS and Icons
############
gem 'sass', '~> 3.3.14'
gem 'sass-rails'
gem 'foundation-rails'
gem "font-awesome-rails"
gem 'uglifier'#, '>= 1.3.0'
gem 'sprockets-rails', '2.3.3'

#########
# Templating
#########
gem "slim-rails"


group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

group :production do
  gem "rails_12factor"
end

group :development, :development_public, :development_remote, :test do
  # pretty printing of objects (for debugging)
  gem "awesome_print"
  # debugging! `binding.pry` to initiate!
  gem "pry-byebug"
  # pretty logs!
  gem "formatted_rails_logger"
  # managing and traversing time in specs
  gem 'delorean'
  # fast web server
  gem 'puma'
  # linting
  gem 'rubocop'
end


group :test do
  # Mimicking objects
  gem "metahash-rb", require: "metahash"

  # The test runner
  gem "rspec"
  gem "rspec-rails"
  gem 'fuubar'

  gem "factory_girl_rails"
  gem "factory_girl", github: "thoughtbot/factory_girl"

  # Mock Stripe objects
  gem 'stripe-ruby-mock', '~> 2.2.1', :require => 'stripe_mock'

  gem 'database_cleaner'

  # Local Coverage Metrics
  gem 'simplecov', :require => false
  # Coverage Reporting
  gem 'codeclimate-test-reporter'
end
