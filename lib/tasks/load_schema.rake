# frozen_string_literal: true

# http://stackoverflow.com/questions/8829725/i18n-how-to-check-if-a-translation-key-value-pairs-is-missing
namespace :db do
  namespace :schema do
    task load: :environment do
      return if Rails.env.production?

      load_schema = lambda do
        # ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')
        load "#{Rails.root}/db/schema.rb" # use db agnostic schema by default
        # ActiveRecord::Migrator.up('db/migrate') # use migrations
        ap 'Database loaded'
      end

      silence_stream(STDOUT, &load_schema)
    end
  end
end
