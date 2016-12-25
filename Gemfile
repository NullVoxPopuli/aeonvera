# frozen_string_literal: true
source 'https://rubygems.org'

ruby '2.3.3'

##########
# Core
##########

gem 'rails', '~> 4.2'
gem 'i18n'
gem 'rack-cors', require: 'rack/cors' # for cross-origin resource sharing
gem 'pg' # database
gem 'attr_encrypted' # column encryption

gem 'goldiloader' # automatic includes on everything (AR)
gem 'skinny_controllers' # , path: '../skinny_controllers' # controllers, chill out!
# gem 'rails_module_unification', github: 'NullVoxPopuli/rails_module_unification'#, path: '../rails_module_unification'
gem 'drawers' # , path: '../rails_module_unification'
gem 'devise' # User Authentication and management
gem 'paranoia', '~> 2.0' # soft deletion
gem 'mail'
gem 'roadie', '~> 2.4.3' # enables rails' layouts for emails
gem 'ransack' # search
gem 'rollbar'
gem 'will_paginate', '~> 3.1.0' # pagination
# Background Tasks
gem 'sidekiq'
gem 'sidekiq-scheduler'
gem 'sidekiq-rollbar'

# Cache
gem 'redis'
gem 'api_cache', github: 'NullVoxPopuli/api_cache'

# JSON serialization
# gem 'active_model_serializers', git: 'https://github.com/NullVoxPopuli/active_model_serializers.git', branch: 'fields-also-whitelists-relationships'
# gem 'active_model_serializers' , github: 'rails-api/active_model_serializers'
# gem 'active_model_serializers', path: '../active_model_serializers'
# gem 'active_model_serializers', github: 'bf4/active_model_serializers', branch: 'smarter_association_id_lookup'
gem 'active_model_serializers'
gem 'oj'
gem 'oj_mimic_json'

gem 'stripe' # Stripe Payment Processing

# Uploads
gem 'paperclip', '~> 5.0.0.beta2'
gem 'aws-sdk' # Upload Storage on S3

# validation
gem 'date_validator'

gem 'newrelic_rpm' # app performance monitoring

############
# JS, CSS and Icons (For Emails)
############
gem 'sass', '~> 3.3.14'
gem 'sass-rails'
gem 'foundation-rails'
gem 'font-awesome-rails'
gem 'sprockets-rails', '2.3.3'
gem 'uglifier' # for heroku asset precompilation. :-(

#########
# Templating
#########
gem 'slim-rails'
gem 'arbre'

group :development, :development_public, :development_remote, :test do
  # pretty printing of objects (for debugging)
  gem 'awesome_print'
  # debugging! `binding.pry` to initiate!
  gem 'pry-byebug'
  # pretty logs!
  gem 'formatted_rails_logger'
  # managing and traversing time in specs
  gem 'delorean'
  # fast web server
  gem 'puma'
  # linting
  gem 'rubocop'
  # list the fields in models
  gem 'annotate'
  # capturing emails
  gem 'letter_opener_web'

  # hopefully eventually used in AMS...
  gem 'case_transform'
end

group :test do
  # Mimicking objects
  gem 'metahash-rb', require: 'metahash'

  # The test runner
  gem 'rspec'
  gem 'rspec-rails'
  gem 'fuubar'

  gem 'factory_girl_rails'
  gem 'factory_girl', github: 'thoughtbot/factory_girl'

  # Mock Stripe objects
  gem 'stripe-ruby-mock', '~> 2.2.1', require: 'stripe_mock'

  gem 'database_cleaner'

  # Local Coverage Metrics
  gem 'simplecov', require: false
  # Coverage Reporting
  gem 'codeclimate-test-reporter'
end
