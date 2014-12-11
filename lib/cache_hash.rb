require "cache_hash/version"

class CacheHash
  # CacheHash is a simple hash implementation where the 
  # value is purged after TTL seconds.
  
  attr_reader :ttl, :gc_interval
  
  # Creates CacheHash and starts garbage collection
  # @param [seconds] ttl Number to seconds to retain value
  # @param [seconds] gc_interval Seconds to wait between GC
  def initialize(ttl: 60, gc_interval: 10)
    @data = Hash.new
    @mutex = Mutex.new
    @gc_thread = nil

    @ttl  = ttl
    @gc_interval = gc_interval # seconds
    start_gc
  end
  
  # Sets a value for a key and returns the value
  # @param [Object] key
  # @param [Object] value
  # @return [Object] value
  def []=(key, value)
    @mutex.synchronize {
      @data[key] = {
        value: value,
        expires_at: Time.now.to_i + @ttl
      }
    }
    value
  end
  
  # Gets value for key, or nil if expired
  # @param [Object] key
  # @return [Object, nil]
  def [](key)
    @mutex.synchronize {
      if @data.has_key?(key)
        if Time.now.to_i > @data[key][:expires_at]
          # @data.delete(key)
          return nil
        else
          return @data[key][:value]
        end
      end
    }
    return nil
  end
  
  # Gets value for key, or default_value if expired
  # @param [Object] key
  # @param [Object] default_value
  # @param [Block]
  # @return [Object, nil]
  def fetch(key, default_value = nil)
    raise ArgumentError, "Block not given" if (block_given? && default_value)
    self[key] || default_value || (self[key] = yield) # (*args))
  end
    
  # Kick off garbage collection in a thread
  def start_gc
    @gc_thread = Thread.new do
      loop do
        sleep @gc_interval
        gc
      end
    end
  end
  
  # Delete keys with expired values
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
