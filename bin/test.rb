#!/usr/bin/env ruby

require 'cache_hash'

def test1
  puts "Testing fetch"
  c = CacheHash.new(ttl: 3, gc_interval: 1)

  c[:a] = "its here"

  sleep 1
  puts c.fetch(:a, "its gone!")

  sleep 1
  puts c.fetch(:a, "its gone!")

  sleep 1
  puts c.fetch(:a, "its gone!")

  sleep 1
  puts c.fetch(:a, "its gone!")

  sleep 1
  puts c.fetch(:a, "its gone!")
end

def test2
  puts "Testing array syntax"
  c = CacheHash.new(ttl: 3, gc_interval: 1)

  c[:a] = "its here"

  sleep 1
  puts c[:a] || "its gone!"

  sleep 1
  puts c[:a] || "its gone!"

  sleep 1
  puts c[:a] || "its gone!"

  sleep 1
  puts c[:a] || "its gone!"

  sleep 1
  puts c[:a] || "its gone!"

  sleep 1
  puts c[:a] || "its gone!"

  sleep 1
  puts c[:a] || "its gone!"


end


test2
test1
