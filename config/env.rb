# Configures and loads the necessary files to run the application
require 'rubygems'
require 'bundler'
require 'json'

ENV['RACK_ENV'] ||= 'development'

Bundler.require(:default, ENV['RACK_ENV'])

ROOT_PATH = Pathname.new(File.expand_path('..', File.dirname(__FILE__)))

%w[initializers lib app].each do |directory|
  directory = File.join('config', directory) if directory == 'initializers'
  Dir[File.expand_path(File.join(ROOT_PATH, directory,'**','*.rb'))].each {|file| require file }
end
