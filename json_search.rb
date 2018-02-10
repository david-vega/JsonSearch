#!/usr/bin/env ruby

begin
  system 'clear'
  require File.join(File.expand_path(File.dirname(__FILE__)), 'config', 'env.rb')

  ConsoleSearchIO.new.start
  exit(0)
rescue => exception
  STDERR.puts "Oops! You broke it!\n  Error: #{exception.to_s.bold}".red
  exit(1)
end
