require_relative '../spec_helper'

RSpec.describe 'root routes' do
  it 'should tell you wrong castle' do
    get '/'
    expect(last_response).to be_ok
    expect(last_response.body).to match('wrong castle')
  end

  it 'should allow CORS' do
    get '/'
    expect(last_response).to be_ok
    expect(last_response.headers['Access-Control-Allow-Origin'])
      .to eq('http://localhost')
  end

  it 'responds to OPTIONS' do
    options '/'
    expect(last_response).to be_ok
    expect(last_response.headers['Access-Control-Allow-Headers'])
      .to eq('X-Requested-With, X-HTTP-Method-Override, Content-Type, Cache-Control, Accept')
  end
end
