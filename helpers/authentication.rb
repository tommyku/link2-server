require 'multi_json'

module Sinatra
  module Authentication
    def authenticate!
      puts request
      # Authenticate client here

      halt 401, MultiJson.dump({message: "You are not authorized to access this resource"}) unless authenticated?
    end

    def authenticated?
      true # for now
    end
  end

  helpers Authentication
end
