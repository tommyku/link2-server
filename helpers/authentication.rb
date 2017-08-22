require 'multi_json'
require 'jwt'
require 'jwe'

module Sinatra
  module Authentication
    def authenticate!
      halt 401, 'you can\'t' unless authenticated?
    end

    def authenticated?
      return false unless access_token
      token = Token.decode(access_token)
      return false unless token || token.expired?
      token.payload && token.payload[:user_id]
    end

    def access_token
      request.env['HTTP_ACCESS_TOKEN'] || request['HTTP_ACCESS_TOKEN']
    end
  end

  helpers Authentication
end
