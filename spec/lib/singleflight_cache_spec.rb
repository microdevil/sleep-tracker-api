require "rails_helper"
require "singleflight_cache"

RSpec.describe SingleflightCache do
  let(:key) { "test_key" }
  let(:ttl) { 1 } # short TTL for test
  let(:lock_timeout) { 1 }

  before do
    Rails.cache.delete(key)
  end

  it "caches the result of the block and does not re-execute block if cached" do
    counter = 0
    result = SingleflightCache.fetch(key, ttl: ttl, lock_timeout: lock_timeout) do
      counter += 1
      "expensive"
    end
    expect(result).to eq("expensive")
    # Should return cached value, not re-run block
    result2 = SingleflightCache.fetch(key, ttl: ttl, lock_timeout: lock_timeout) do
      counter += 1
      "different"
    end
    expect(result2).to eq("expensive")
    expect(counter).to eq(1)
  end

  it "recomputes after cache expires" do
    SingleflightCache.fetch(key, ttl: ttl, lock_timeout: lock_timeout) { "first" }
    sleep(ttl + 0.1)
    result = SingleflightCache.fetch(key, ttl: ttl, lock_timeout: lock_timeout) { "second" }
    expect(result).to eq("second")
  end
end
