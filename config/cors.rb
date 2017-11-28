before do
  response.headers['Access-Control-Allow-Origin'] = ENV['CORS_ORIGIN'] || 'http://localhost'
end

options '*' do
  response.headers['Allow'] = 'HEAD,GET,PUT,POST,DELETE,OPTIONS'
  response.headers['Access-Control-Allow-Headers'] = 'X-Requested-With, X-HTTP-Method-Override, Content-Type, Cache-Control, Accept'
  200
end
