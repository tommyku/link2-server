require_relative './authentication'
require_relative './request_body'
require_relative './request_helper'

before(%r{/api/links.*}) do
  authenticate!
end

before([%r{/api/links.*}, '/login']) do
  content_type :json
  cross_origin
  set_body_json
end
