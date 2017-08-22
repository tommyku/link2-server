module Sinatra
  module RequestHelper
    def current_user
      return @current_user if @current_user
      token = Token.decode(access_token)
      user = User[token.payload[:user_id]] if token.valid?
      @current_user = user
    end
  end

  helpers RequestHelper
end
