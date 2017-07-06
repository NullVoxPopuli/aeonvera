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

Thread.new do
  # wait long enough for redis to boot
  # sleep(2)

  redis_conn = proc {
    config = URI.parse(ENV['REDIS_URL'])
    Redis.new(host: config.host, port: config.port, password: config.password)
  }

  Sidekiq.configure_client do |config|
    config.redis = ConnectionPool.new(size: 5, &redis_conn)
  end

  Sidekiq.configure_server do |config|
    config.redis = ConnectionPool.new(size: 5, &redis_conn)
    config.on(:startup) do
      # In case we have lots of crons, migrating to this yml might be a good idea
      config_path = Rails.root.join('config', 'scheduler.yml')
      config = YAML.load_file(config_path)
      Sidekiq.schedule = config
      Sidekiq::Scheduler.reload_schedule!
    end
  end

end if ENV['THREADED_SIDEKIQ']

Sidekiq::Web.use(Rack::Auth::Basic) do |username, password|
  # Protect against timing attacks:
  # - See https://codahale.com/a-lesson-in-timing-attacks/
  # - See https://thisdata.com/blog/timing-attacks-against-string-comparison/
  # - Use & (do not use &&) so that it doesn't short circuit.
  # - Use digests to stop length information leaking
  #  (see also ActiveSupport::SecurityUtils.variable_size_secure_compare)
  ActiveSupport::SecurityUtils.secure_compare(
    ::Digest::SHA256.hexdigest(username),
    ::Digest::SHA256.hexdigest(ENV['SIDEKIQ_USERNAME'])
  ) &
    ActiveSupport::SecurityUtils.secure_compare(
      ::Digest::SHA256.hexdigest(password),
      ::Digest::SHA256.hexdigest(ENV['SIDEKIQ_PASSWORD'])
    )
end
