require_relative './authentication'
require_relative './request_body'

before(%r{/api/links.*}) do
  authenticate!
end

before(%r{/api/links.*}) do
  set_body_json
end
