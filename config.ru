#$LOAD_PATH.unshift ('/home/eschaton/.gem/ruby/1.8/gems/rack-0.9.1/lib')
#require ('/home/eschaton/.gem/ruby/1.8/gems/rack-0.9.1/lib/rack.rb')
#require ('/home/eschaton/.gem/ruby/1.8/gems/sinatra-0.9.1.1/lib/sinatra.rb')

#$LOAD_PATH.unshift '/Library/Ruby/Gems/1.8/gems/sqlite3-ruby-1.2.4/lib'
#require ('/Library/Ruby/Gems/1.8/gems/sqlite3-ruby-1.2.4/sqlite3.rb')
#$LOAD_PATH.unshift '/Library/Ruby/Gems/1.8/gems/sequel-3.0.0/lib'
#require ('/home/eschaton/.gems/gems/sequel-2.12.0/lib/sequel.rb')

require 'rubygems'
require 'sequel'
require 'rack'
require 'sinatra'

#require File.expand_path('~/.gem/ruby/1.8/gems/rack*')
#require File.expand_path('~/.gem/ruby/1.8/gems/sinatra*')

#Sinatra::Application.default_options.merge!(
#  :views => File.join(File.dirname(__FILE__), 'views'),
#  :run => false,
#  :env => ENV['RACK_ENV'],
#  :raise_errors => true
#)

#log = File.new("sinatra.log", "a")
#$stdout.reopen(log)
#$stderr.reopen(log)

require 'main'

run Sinatra::Application
