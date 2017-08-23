require_relative '../spec_helper'

RSpec.describe 'auth routes' do
  describe 'login' do
    it 'returns 401 on failed auth' do
      allow(User).to receive(:authenticate).and_return(false)

      post '/login', { username: 'test', password: 'test'}.to_json

      expect(last_response.status).to eq 401
    end

    it 'returns access_token on successful auth' do
      @user = double(:user, id: 1, username: 'test')
      allow(User).to receive(:authenticate).and_return(true)
      allow(User).to receive(:[]).and_return(@user)
      allow(Token).to receive_message_chain(:new, :encode).and_return('token')

      post '/login', { username: 'test', password: 'test'}.to_json

      expect(last_response).to be_ok
      expect(last_response.body).to eq({
        username: 'test',
        access_token: 'token'
      }.to_json)
    end
  end
end
