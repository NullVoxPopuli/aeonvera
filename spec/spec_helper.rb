# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
require 'database_cleaner'

# for local test coverage metrics
if ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.start
end

# for test coverage reporting to codeclimate
if ENV['CODECLIMATE_REPO_TOKEN']
  require 'codeclimate-test-reporter'
  CodeClimate::TestReporter.start
end

load_schema = lambda do
  load "#{Rails.root.to_s}/db/schema.rb" # use db agnostic schema by default
  ActiveRecord::Migrator.up('db/migrate') # use migrations
end

silence_stream(STDOUT, &load_schema)

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

# for debugging, sometimes it's helpful to see the sql for each request
# especially for our complicated / numerous relationships
if ENV['SQL']
  show_sql
end

RSpec.configure do |config|

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
  config.order = "random"

  # RSpec
  config.include Devise::TestHelpers, type: :controller

  # https://github.com/plataformatec/devise/wiki/How-To:-Test-with-Capybara
  config.include Warden::Test::Helpers, type: :feature
  config.include FormHelpers, type: :feature
  Warden.test_mode!
  # Capybara.javascript_driver = :webkit
  Capybara.javascript_driver = :poltergeist
  Capybara.server_port = 3001


  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.before(:each, js: true) do
    # speeds up feature testing

    # tracking
    page.driver.block_url "https://stats.g.doubleclick.net"
    page.driver.block_url "www.google-analytics.com"

    # test event url
    page.driver.allow_url("testevent.test.local.vhost")
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end

  config.after(type: :feature) do |example|
    Warden.test_reset!
    # if example.metadata[:type] == :feature and example.exception.present?
    #   save_and_open_page
    # end
  end

end
