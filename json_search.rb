#!/usr/bin/env ruby

# Runs the application from the command line
begin
  require File.join(File.expand_path(File.dirname(__FILE__)), 'config', 'env.rb')

  SystemConsoleIO::JsonSearchIO.new.start
  exit(0)
rescue => exception
  STDERR.puts "Oops! You broke it!\n  Error: #{exception.to_s.bold}".red
  exit(1)
end
