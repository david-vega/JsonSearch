require 'rubygems'
require 'bundler'

ENV['RACK_ENV'] ||= 'development'

Bundler.require(:default, ENV['RACK_ENV'])

root_path = Pathname.new(File.expand_path('..', File.dirname(__FILE__)))
%w[lib].each do |directory|
  Dir[File.expand_path(File.join(root_path, directory,'**','*.rb'))].each {|file| require file }
end

