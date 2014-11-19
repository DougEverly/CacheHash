require "cache_hash/version"

class CacheHash
  def initialize(ttl: 3600, gc_interval: 60)
    @data = Hash.new
    @mutex = Mutex.new
    @gc_thread = nil

    @ttl  = ttl
    @gc_interval = gc_interval # seconds
    start_gc
  end
  
  def []=(key, value)
    @mutex.synchronize {
      @data[key] = {
        value: value,
        expires_at: Time.now.to_i + @ttl
      }
    }
  end
  
  def [](key)
    @mutex.synchronize {
      if @data.has_key?(key)
        if Time.now.to_i > @data[key][:expires_at]
          @data.delete(key)
          return nil
        else
          return @data[key][:value]
        end
      end
    }
    return nil
  end
  
  def fetch(key, default_value)
      self[key] or default_value
  end
  
  def start_gc
    @gc_thread = Thread.new do
      loop do
        sleep @gc_interval
        gc
      end
    end
  end
  
  def gc
    now = Time.now.to_i
    @mutex.synchronize {
      @data.each_pair do |key, value|
        if now > @data[key][:expires_at]
          @data.delete key
        end
      end
    }
  end
  
end
