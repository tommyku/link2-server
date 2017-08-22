login = lambda do
  content_type :json

  username = @body_json[:username]
  password = @body_json[:password]

  halt 401 unless User.authenticate(username, password)

  user = User[username: username]
  access_token = Token.new(user_id: user.id).encode

  MultiJson.dump(username: username, access_token: access_token)
end

post '/login', &login
