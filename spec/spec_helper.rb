# frozen_string_literal: true
# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'

require 'simplecov'

SimpleCov.start do
  add_group 'Models', 'app/models'
  add_group 'Controllers', '.*controller.*'
  add_group 'Operations', '.*operation.*'
  add_group 'Policies', '.*polic.*'
  add_group 'Mailers', 'app/mailers'
  add_group 'Serializers', '.*serializer.*'
  add_group 'Services', 'app/services'

  # filters.clear
  add_filter '/app/controllers/[^a][^p][^i]'
  add_filter '/app/helpers/'
  add_filter '/app/decorators/'
  add_filter '/app/views/'
  add_filter '/gems/'
  add_filter '/spec/'
  add_filter '/config/'
  add_filter '/public/'
  add_filter '/db/'
end

require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }
Dir[Rails.root.join('spec/requests/shared_examples/**/*.rb')].each { |f| require f }

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

# for debugging, sometimes it's helpful to see the sql for each request
# especially for our complicated / numerous relationships
show_sql if ENV['SQL']

puts "!Env: #{Rails.env}:#{ENV['RAILS_ENV']}"

# USE A FREAKING NORMAL TIMEZONE, SORRY INDIANA
Time.zone = 'Central Time (US & Canada)'

RSpec.configure do |config|
  config.after(:each, type: :request) do |example|
    if example.exception
      begin
        ap JSON.parse(response.body)
      rescue => e
        # probably not j son
      end
    end
  end

  config.after(:each, type: :controller) do |example|
    if example.exception
      begin
        ap JSON.parse(response.body)
      rescue => e
        # probably not j son
      end
    end
  end

  # Automatically Adding Metadata RSpec versions before 3.0.0 automatically added
  # metadata to specs based on their location on the filesystem. This was both
  # confusing to new users and not desirable for some veteran users.
  config.infer_spec_type_from_file_location!

  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  #
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = 'random'
end
