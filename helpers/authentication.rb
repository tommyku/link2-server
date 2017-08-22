require 'multi_json'

module Sinatra
  module Authentication
    def authenticate!
      # Authenticate client here

      halt 401, 'you can\'t' unless authenticated?
    end

    def authenticated?
      true # for now
    end
  end

  helpers Authentication
end
