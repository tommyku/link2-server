require 'sinatra'
require 'sinatra/config_file'
require 'sinatra/cross_origin'
require 'sequel'
require 'net/http'
require_relative './config/init'
require_relative './helpers/init'
require_relative './services/init'
require_relative './models/init'
require_relative './routes/init'

config_file './config/config.yml'
