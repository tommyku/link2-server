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
      return false unless token.valid?
      user = User[token.payload[:user_id]]
      return false unless user
      true
    end

    def access_token
      request.env['HTTP_ACCESS_TOKEN'] || request['HTTP_ACCESS_TOKEN']
    end

    private
  end

  helpers Authentication
end
