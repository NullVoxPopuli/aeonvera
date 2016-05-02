if !(Rails.env.production? || Rails.env.staging?)
  require 'rspec/core/rake_task'

  namespace :spec do

    desc 'Run all specs in spec directory'
    RSpec::Core::RakeTask.new(:api) do |task|
      # ensure the database is setup
      `RAILS_ENV=test rake db:create`
      `RAILS_ENV=test rake db:schema:load`

      task.pattern = [
        'spec/controllers/api',
        'spec/controllers/marketing_controller_spec.rb',
        'spec/mailers',
        'spec/models',
        'spec/operations',
        'spec/policies',
        'spec/services',
        'spec/requests'
      ]
    end

  end
end
