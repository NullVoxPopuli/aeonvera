# config/initializers/sidekiq_scheduler.rb
require 'sidekiq/scheduler'
require 'sidekiq/cli'
require 'sidekiq/web'

puts "Sidekiq.server? is #{Sidekiq.server?.inspect}"
puts "defined?(Rails::Server) is #{defined?(Rails::Server).inspect}"
puts "defined?(Unicorn) is #{defined?(Unicorn).inspect}"
puts "defined?(Puma) is #{defined?(Puma).inspect}"

Sidekiq::Scheduler.enabled = true
Sidekiq::Scheduler.dynamic = true

if defined?(Rails::Server) || defined?(Unicorn) || defined?(Puma)
  Sidekiq.configure_server do |config|
    config.on(:startup) do
      # In case we have lots of crons, migrating to this yml might be a good idea
      config_path = Rails.root.join('config', 'scheduler.yml')
      config = YAML.load_file(config_path)
      Sidekiq.schedule = config
      Sidekiq::Scheduler.reload_schedule!
    end
  end

  # Using Heroku Worker
  #
  # Locally, run
  #  bundle exec sidekiq -q default -q mailers -q daemons

  if ENV['THREADED_SIDEKIQ']
    Rails.logger.info('Starting Sidekiq in a thread...')
    Thread.new do
      cli = Sidekiq::CLI.instance
      cli.parse(['-C', './config/sidekiq.yml', '-L', 'log/sidekiq.log'])
      cli.run
    end
  end
else
  Sidekiq::Scheduler.enabled = false
  puts "Sidekiq::Scheduler.enabled is #{Sidekiq::Scheduler.enabled.inspect}"
end

Sidekiq::Web.use(Rack::Auth::Basic) do |email, password|
  # user = User.find_by_email(email)
  # user.try(:authenticate, password)
  true
end
