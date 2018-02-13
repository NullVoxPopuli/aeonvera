# frozen_string_literal: true

# http://stackoverflow.com/questions/8829725/i18n-how-to-check-if-a-translation-key-value-pairs-is-missing
namespace :db do
  # TODO: add go and gdrive to dockerfile
  task :backup do

  end

  namespace :schema do
    def database_exists?
      ActiveRecord::Base.connection
    rescue ActiveRecord::NoDatabaseError
      false
    else
      true
    end

    task setup_or_migrate: :environment do
      begin
        ActiveRecord::Base.connection
      rescue ActiveRecord::NoDatabaseError
        Rake::Task['db:create'].execute
        load "#{Rails.root}/db/schema.rb"
      else
        Rake::Task['db:migrate'].execute
      end
    end

    task load: :environment do
      return if Rails.env.production?

      load_schema = lambda do
        # ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')
        load "#{Rails.root}/db/schema.rb" # use db agnostic schema by default
        # ActiveRecord::Migrator.up('db/migrate') # use migrations
        puts 'Database loaded'
      end

      silence_stream(STDOUT, &load_schema)
    end
  end
end
