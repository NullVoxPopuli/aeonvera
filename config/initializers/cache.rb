# Globally set up redis
redis = nil
if ENV["REDISCLOUD_URL"].present?
	config = URI.parse(ENV["REDISCLOUD_URL"])
	redis = Redis.new(host: config.host, port: config.port, password: config.password)
else
	config = YAML::load(File.open("#{Rails.root.to_s}/config/redis.yml"))[Rails.env]
	redis = Redis.new(:host => config['host'], :port => config['port'])
end

begin
	redis.ping
	puts "Connection to Redis Caching Server Established"
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
		begin
			APICache.store.set(key, Marshal.dump(value))
		rescue => e
			return false
		end
	end

	def self.delete(key)
		begin
			APICache.store.delete(key)
		rescue
			return false
		end
	end

	def self.get(key)
		begin
			result = APICache.store.get(key)
			return Marshal.load(result) if result and !result.empty?
		rescue => e
			return false
		end
	end

	def self.expire(key, seconds)
		begin
			result = APICache.store.expire(key, seconds)
			return result
		rescue => e
			return false
		end
	end
end
