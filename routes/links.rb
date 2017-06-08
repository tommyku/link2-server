require 'sinatra'
require 'multi_json'

get '/api/links' do
  # return links on page X
  page = params[:page] || '0';
  page
end

get '/api/links/:id' do |id|
  "id is #{id}"
end

post '/api/links' do
  puts @body_json
	"ok"
end

put '/api/links' do
  puts @body_json
	"ok"
end

delete '/api/links/:id' do |id|
	"id is #{id}"
end
