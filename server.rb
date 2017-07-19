require 'sinatra'
require 'sinatra/config_file'
require 'sequel'
require_relative './config/init'
require_relative './helpers/init'
require_relative './models/init'
require_relative './routes/init'

config_file './config/config.yml'
