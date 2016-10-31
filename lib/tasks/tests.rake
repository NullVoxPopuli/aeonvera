if !(Rails.env.production? || Rails.env.staging?)
  require 'rspec/core/rake_task'

  namespace :spec do

    desc 'Run all specs in spec directory'
    RSpec::Core::RakeTask.new(:api) do |task|
      # task.rspec_opts = '--pattern "**{,/*/**}/*_spec.rb"'

      # ensure the database is setup
      `RAILS_ENV=test rake db:create`
      `RAILS_ENV=test rake db:schema:load`
    end
  end
end
