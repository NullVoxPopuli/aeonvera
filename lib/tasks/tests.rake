# frozen_string_literal: true
unless Rails.env.production? || Rails.env.staging?
  require 'rspec/core/rake_task'

  namespace :spec do
    desc 'Run all specs in spec directory'
    RSpec::Core::RakeTask.new(:api) do |_task|
      # ensure the database is setup
      `RAILS_ENV=test rake db:create`
      `RAILS_ENV=test rake db:schema:load`
    end
  end
end
