require 'database_cleaner'

def using_sqlite3?
  ActiveRecord::Base.connection_config[:adapter] == 'sqlite3'
end

def using_postgresql?
  ActiveRecord::Base.connection_config[:adapter] == 'postgresql'
end

RSpec.configure do |config|

  # config.use_transactional_examples = false

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

end
