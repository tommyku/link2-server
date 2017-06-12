require 'sinatra'
require 'sinatra/config_file'
require 'sequel'

config_file './config/config.yml'

DB = Sequel.connect('sqlite://database/db.sqlite3')

%w{helpers models routes}.each do |dir|
  $LOAD_PATH << File.expand_path('.', File.join(File.dirname(__FILE__), dir))
  require File.join('.', dir, 'init')
end
