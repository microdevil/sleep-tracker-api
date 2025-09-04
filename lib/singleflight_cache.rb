require "redis"
require "redis-mutex"

# Assign a Redis client for RedisMutex
RedisClassy.redis ||= Redis.new(url: ENV.fetch("REDIS_URL"))

# Provides singleflight caching to prevent duplicate expensive computations for the same key.
# Usage: SingleflightCache.fetch(key, ttl: 300, lock_timeout: 10) { ...expensive computation... }
module SingleflightCache
  def self.fetch(key, ttl: 300, lock_timeout: 10)
    # Fast path: return cached value if present
    value = Rails.cache.read(key)
    return value if value

    mutex = RedisMutex.new("lock:#{key}", block: lock_timeout)
    mutex.with_lock do
      # Double-check cache after acquiring lock
      value = Rails.cache.read(key)
      return value if value

      # Compute and write only if cache is still empty
      value = yield # <-- expensive computation happens here
      Rails.cache.write(key, value, expires_in: ttl)
      value
    end
  end
end
