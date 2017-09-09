require_relative '../spec_helper'

RSpec.describe 'Sinatra::Authentication' do
  class AuthenticationHelper
    include Sinatra::Authentication

    def request
    end
  end

  describe '#access_token' do
    before :each do
      @authenticationHelper = AuthenticationHelper.new
      @token = Token.new(user_id: 1).encode
      allow(@authenticationHelper).to receive_message_chain(:request, :env).and_return({
        'HTTP_AUTHENTICATION' => "Bearer #{@token}"
      })
    end

    it 'returns access token if a match is found' do
      expect(@authenticationHelper.access_token).to eq @token
    end

    it 'returns nil if a match is not found' do
      allow(@authenticationHelper).to receive_message_chain(:request, :env).and_return({
        'HTTP_AUTHENTICATION' => "123123123123"
      })

      expect(@authenticationHelper.access_token).to be_nil
    end
  end

  describe '#authenticated?' do
    before :each do
      @authenticationHelper = AuthenticationHelper.new
      @token = Token.new(user_id: 1)
      @encoded_token = @token.encode
      allow(@authenticationHelper).to receive(:access_token).and_return(@encoded_token)
      allow(Token).to receive(:decode).and_return(@token)
      allow(@token).to receive(:valid?).and_return(true)
      allow(User).to receive(:[]).and_return(true)
    end

    it 'returns true if user is authenticated' do
      expect(@authenticationHelper.authenticated?).to be_truthy
    end

    it 'returns false if token is nil' do
      allow(@authenticationHelper).to receive(:access_token).and_return(nil)

      expect(@authenticationHelper.authenticated?).to be_falsy
    end

    it 'returns false if token is invalid' do
      allow(@token).to receive(:valid?).and_return(false)

      expect(@authenticationHelper.authenticated?).to be_falsy
    end

    it 'returns false if User is not found' do
      allow(User).to receive(:[]).and_return(false)

      expect(@authenticationHelper.authenticated?).to be_falsy
    end
  end
end
