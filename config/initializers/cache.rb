# frozen_string_literal: true

# 'Globally' set up redis
redis = nil

if ENV['REDIS_URL'].present?
  config = URI.parse(ENV['REDIS_URL'])
  redis = Redis.new(host: config.host, port: config.port, password: config.password)
else
  config = YAML.safe_load(File.open("#{Rails.root}/config/redis.yml"))[Rails.env]
  redis = Redis.new(host: config['host'], port: config['port'])
end

begin
  redis.ping
  puts 'Connection to Redis Caching Server Established'
rescue
  # ping throws an exception if redis doesn't exist or the host / port are wrong
  puts 'Redis Server not found. Please run/configure redis.'
end

# this wrapper is just for error handeling
module Cache
  class << self

    def set(key, value)
      redis.set(key, Marshal.dump(value))

      true
    rescue
      false
    end

    def delete(key)
      redis.del(key)
    rescue
      false
    end

    def get(key)
      result = redis.get(key)

      return Marshal.load(result) if result && !result.empty?
    rescue
      false
    end

    def expire(key, seconds)
      return redis.expire(key, seconds)
    rescue
      false
    end
  end
end
