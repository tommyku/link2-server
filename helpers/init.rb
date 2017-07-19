require_relative './authentication'
require_relative './request_body'

before do
  authenticate!
end

before '/api/links' do
  set_body_json
end
