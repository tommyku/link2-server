require_relative '../spec_helper'

RSpec.describe 'root routes' do
  it 'should tell you wrong castle' do
    get '/'
    expect(last_response).to be_ok
    expect(last_response.body).to match('wrong castle')
  end
end
