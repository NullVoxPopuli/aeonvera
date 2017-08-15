# frozen_string_literal: true

# Globally set up redis
redis = nil
if ENV['REDIS_URL'].present?
  config = URI.parse(ENV['REDIS_URL'])
  redis = Redis.new(host: config.host, port: config.port, password: config.password)
else
  config = YAML.load(File.open("#{Rails.root}/config/redis.yml"))[Rails.env]
  redis = Redis.new(host: config['host'], port: config['port'])
end

begin
  redis.ping
  puts 'Connection to Redis Caching Server Established'
  APICache.store = APICache::RedisStore.new(redis)
rescue => e
  # ping throws an exception if redis doesn't exist or the host / port are wrong
  puts "Redis Server not found, using MemoryStore: #{e.message}."
  # switch to a MemoryStore if redis is not available
  APICache.store = APICache::MemoryStore.new
end

# this wrapper is just for error handeling
module Cache
  def self.set(key, value)
    APICache.store.set(key, Marshal.dump(value))
  rescue => e
    return false
  end

  def self.delete(key)
    APICache.store.delete(key)
  rescue
    return false
  end

  def self.get(key)
    result = APICache.store.get(key)
    return Marshal.load(result) if result && !result.empty?
  rescue => e
    return false
  end

  def self.expire(key, seconds)
    result = APICache.store.expire(key, seconds)
    return result
  rescue => e
    return false
  end
end
