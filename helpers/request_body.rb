require 'multi_json'

module Sinatra
  module RequestBody
    def set_body_json
      request.body.rewind
      @body_json = {}
      begin
        json_string = request.body.read || '{}'
        @body_json = MultiJson.load(json_string, symbolize_keys: true)
      rescue MultiJson::ParseError
        @body_json = {}
      end
    end
  end

  helpers RequestBody
end
