# CacheHash

Simple hash with expiring values.

* Simple - Returns value or nil.
* Default - Returns value or default
* Block - Returns value, or refreshes the value by yielding to long running job.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'cache_hash'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cache_hash

## Usage

### Simple

Returns value or nil.

    c = CacheHash.new(ttl: 3)
    c[:a] = "its here"
    puts c[:a] # => "its here" or nil if called after 3 seconds

### Default Value

Returns value or default.

    x = 0
    c[:foo] = "HAZ VALUE"
    c.fetch(:foo, "NO VALUE") # => "HAZ VALUE"
    # wait 3 seconds
    c.fetch(:foo, "NO VALUE") # => "NO VALUE"
    

### Block

Returns value, or refreshes the value by yielding to long running job.

    c = CacheHash.new(ttl: 5)
    users = ['smith', 'jones']
    
    # first run loads cache
    
    users.each do |user|
       row = c.fetch(user) {
        # long running job
        get_user(user)
      }
    end
    
    # second run hits cache

    users.each do |user|
       row = c.fetch(user) {
        # long running job
        get_user(user)
      }
    end
    
    
    # third run refreshes cache

    sleep 6
    users.each do |user|
       row = c.fetch(user) {
        # long running job
        get_user(user)
      }
    end


    c = CacheHash.new(ttl: 2, gc_interval: 1)

    

## Contributing

1. Fork it ( https://github.com/[my-github-username]/cache_hash/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
