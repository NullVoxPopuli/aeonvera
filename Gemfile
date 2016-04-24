source 'https://rubygems.org'

# ruby (ENV['RUBY_VERSION'] || '2.3.0')
##########
# Core
##########

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails'
gem 'i18n'
# Use Active Record to store sessions
gem 'activerecord-session_store'
# for cross-origin resource sharing
gem 'rack-cors', :require => 'rack/cors'
# JSON serialization
# gem "active_model_serializers", github: "rails-api/active_model_serializers"
# gem "active_model_serializers", github: "rails-api/active_model_serializers", tag: 'v0.10.0.rc4'
gem "active_model_serializers", git: "https://github.com/NullVoxPopuli/active_model_serializers.git", branch: 'underscored_keys_support_for_deserialization'
# Rediculousness for deserializing embedded data
# gem 'jsonapi_parser', '~>0.5'

# controllers, chill out!
gem 'skinny_controllers'#, path: '/home/lprestonsegoiii/Development/skinny_controllers'

# model helpers
gem 'date_time_attribute'
gem 'recurring_select'
# controller helpers
gem 'lazy_crud'
# request response helpers
gem 'responders'

# error capturing
gem 'rollbar'

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

# Allows the use of decorators
# https://github.com/drapergem/draper
gem 'draper', '~> 1.0'
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
gem 'paperclip'
# Upload Storage on S3
gem 'aws-sdk', '< 2.0'


############
# JS, CSS and Icons
############
gem 'sass', '~> 3.3.14'
gem 'sass-rails'
gem 'foundation-rails'
gem "font-awesome-rails"
gem 'uglifier'#, '>= 1.3.0'
gem 'coffee-rails'#, '~> 4.0.0'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'jquery-turbolinks'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Form Helpers
gem 'select2-rails'

###########
# Extras
###########
gem 'nprogress-rails'

#########
# Templating
#########
gem "slim-rails"


# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'


group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

group :production do
  gem "rails_12factor"
end

group :development, :development_public, :development_remote do
  # https://github.com/slim-template/slim/wiki/Template-Converters-ERB-to-SLIM
  # convert erb and html to slim
  gem  "html2slim"

  # easier / better error pages
  gem "better_errors"
  gem "binding_of_caller"
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
  # keeps asset requests out of the logs
  gem 'quiet_assets'
  # fast web server
  gem 'puma'
end


group :test do
  # Mimicking objects
  gem "metahash-rb", require: "metahash"


  # In memory database for speed
  gem "sqlite3"

  # The test runner
  gem "rspec"
  gem "rspec-rails"
  gem 'fuubar'

  gem "factory_girl_rails"
  gem "factory_girl", github: "thoughtbot/factory_girl"

  # Mock Stripe objects
  gem 'stripe-ruby-mock', '~> 2.2.1', :require => 'stripe_mock'

  gem 'database_cleaner'

  gem "capybara"
  # Javascript testing
  gem "capybara-webkit", "~> 1.4.0"
  # Alternative Javascript Driver - used on travis.ci
  gem "poltergeist"

  # For opening web pages for debugging
  gem 'launchy'

  # Local Coverage Metrics
  gem 'simplecov', :require => false
  # Coverage Reporting
  gem 'codeclimate-test-reporter'
end
