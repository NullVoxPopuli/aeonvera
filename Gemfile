# frozen_string_literal: true

source 'https://rubygems.org'

ruby '~> 2.4.0'

##########
# Core
##########

gem 'rails', '~> 4.2'
gem 'i18n'
gem 'rack-cors', require: 'rack/cors' # for cross-origin resource sharing
gem 'pg' # database
gem 'attr_encrypted', '~> 1.3.0' # column encryption

# type checking
# gem 'rtype'
# gem 'rtype-native'

gem 'goldiloader' # automatic includes on everything (AR)
gem 'skinny_controllers' # , path: '../skinny_controllers' # controllers, chill out!
# gem 'rails_module_unification', github: 'NullVoxPopuli/rails_module_unification'#, path: '../rails_module_unification'
gem 'drawers' # , path: '../rails_module_unification'
gem 'devise' # User Authentication and management

gem 'dry-validation'
gem 'reform' # Non-Model Validation

gem 'paranoia', '~> 2.0' # soft deletion
gem 'mail'
gem 'roadie', '~> 2.4.3' # enables rails' layouts for emails
gem 'ransack' # search
gem 'rollbar'
gem 'will_paginate', '~> 3.1.0' # pagination
# Background Tasks
gem 'sidekiq'
gem 'sidekiq-scheduler'
# gem 'sidekiq-rollbar'

# Cache
# gem 'redis'
gem 'redis-rails', '5.0.2'

# JSON serialization
# gem 'active_model_serializers', git: 'https://github.com/NullVoxPopuli/active_model_serializers.git', branch: 'fields-also-whitelists-relationships'
# gem 'active_model_serializers' , github: 'rails-api/active_model_serializers'
# gem 'active_model_serializers', path: '../active_model_serializers'
# gem 'active_model_serializers', github: 'bf4/active_model_serializers', branch: 'smarter_association_id_lookup'
gem 'active_model_serializers', '0.10.5'
# held back due to JSONAPI document validations - Not every endpoint is JSONAPI
# gem 'jsonapi-renderer', '0.1.2'
gem 'jsonapi-rb'

gem 'oj'
gem 'oj_mimic_json'

gem 'stripe' # Stripe Payment Processing

# Uploads
gem 'paperclip', '~> 5.0.0.beta2'
gem 'aws-sdk' # Upload Storage on S3

# validation
gem 'date_validator'

# app performance monitoring
# gem 'scout_apm', '>= 2.3.0.pre2', '< 3.0.pre'
# GC Tuning
# gem 'tunemygc'
# Auto-scaling Tuning
# gem 'rails_autoscale_agent'

# fast web server
gem 'puma'

############
# JS, CSS and Icons (For Emails)
############
gem 'sass', '~> 3.3.14'
gem 'sass-rails'
gem 'foundation-rails', '6.4.1.3'
gem 'font-awesome-rails'
gem 'sprockets-rails', '2.3.3'
gem 'uglifier' # for heroku asset precompilation. :-(

#########
# Templating
#########
gem 'render_anywhere', require: false
gem 'slim-rails'
gem 'arbre'

group :development do
  # list the fields in models
  gem 'annotate'
  # capturing emails
  gem 'letter_opener_web'
end

group :development, :test do
  # pretty printing of objects (for debugging)
  gem 'awesome_print'
  # debugging! `binding.pry` to initiate!
  gem 'pry-byebug'
  # pretty logs!
  gem 'formatted_rails_logger'
  # linting
  gem 'rubocop'

  # hopefully eventually used in AMS...
  gem 'case_transform'
  # gem 'case_transform-rust-extensions', require: 'case_transform'

  # Parallel Tests, cause Impatience
  gem 'parallel_tests'
end

group :test do
  # managing and traversing time in specs
  gem 'delorean'

  # The test runner
  gem 'rspec'
  gem 'rspec-rails'
  gem 'fuubar'
  gem 'rspec-sidekiq'

  gem 'factory_girl_rails'
  gem 'factory_girl'

  # Mock Stripe objects
  gem 'stripe-ruby-mock', '~> 2.2.1', require: 'stripe_mock'

  gem 'database_cleaner'

  # Local Coverage Metrics
  gem 'simplecov', require: false
  # Coverage Reporting
  gem 'codeclimate-test-reporter'

  # JSONAPI Validation
  gem 'jsonapi-parser', require: 'jsonapi/parser'
end
