require 'multi_json'
require 'jwt'
require 'jwe'

module Sinatra
  module Authentication
    AUTH_TOKEN_REGEXP = /Bearer ([\d\w\._-]+)/

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
      token_match = (request.env['HTTP_AUTHENTICATION'] || request.params['HTTP_AUTHENTICATION'])&.match(AUTH_TOKEN_REGEXP)
      token_match ? token_match[1] : nil
    end

    private
  end

  helpers Authentication
end
