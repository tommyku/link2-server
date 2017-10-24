require_relative '../spec_helper'

RSpec.describe 'links routes' do
  describe 'list_links' do
    it 'returns 401 when no auth' do
      get '/api/links'
      expect(last_response.status).to eq 401
    end

    it 'returns list of links on auth' do
      @user = double(:user, id: 1, username: 'test', email: 'test@test')
      @link = double(:link, id: 1, user_id: 1)
      @encoded_token = Token.new({ user_id: 1 }).encode

      allow(User).to receive(:[]).and_return(@user)
      allow(LinkService).to receive(:get_collection).and_return([@link])

      header 'AUTHENTICATION', "Bearer #{@encoded_token}"
      get '/api/links'

      expect(last_response).to be_ok
      expect(last_response.body).to eq({ links: [@link] }.to_json)
    end
  end

  describe 'list_random_lists' do
    it 'returns 401 when no auth' do
      get '/api/links/random'
      expect(last_response.status).to eq 401
    end

    it 'returns list of random links on auth' do
      @user = double(:user, id: 1, username: 'test', email: 'test@test')
      @link = double(:link, id: 1, user_id: 1)
      @encoded_token = Token.new({ user_id: 1 }).encode

      allow(User).to receive(:[]).and_return(@user)
      allow(LinkService).to receive(:get_random_collection).and_return([@link])

      header 'AUTHENTICATION', "Bearer #{@encoded_token}"
      get '/api/links/random'

      expect(last_response).to be_ok
      expect(last_response.body).to eq({ links: [@link] }.to_json)
    end
  end

  describe 'get_link' do
    it 'returns 401 when no auth' do
      get '/api/links/1'
      expect(last_response.status).to eq 401
    end

    it 'returns 404 if link is not found' do
      @user = double(:user, id: 1, username: 'test', email: 'test@test')
      @encoded_token = Token.new({ user_id: 1 }).encode

      allow(User).to receive(:[]).and_return(@user)
      allow(Link).to receive(:[]).and_return(nil)

      header 'AUTHENTICATION', "Bearer #{@encoded_token}"
      get '/api/links/1'

      expect(last_response.status).to eq 404
    end

    it 'returns the link on auth' do
      @user = double(:user, id: 1, username: 'test', email: 'test@test')
      @link_hash = { id: 1, user_id: 1 }
      @link = double(:link, @link_hash)
      @encoded_token = Token.new({ user_id: 1 }).encode

      allow(User).to receive(:[]).and_return(@user)
      allow(Link).to receive(:[]).and_return(@link)
      allow(@link).to receive(:to_hash).and_return(@link_hash)
      allow(@link).to receive(:screenshot_uuid).and_return('')

      header 'AUTHENTICATION', "Bearer #{@encoded_token}"
      get '/api/links/1'

      expect(last_response).to be_ok
      expect(last_response.body).to eq({ link: @link_hash }.to_json)
    end
  end

  describe 'post_link' do
    it 'returns 401 when no auth' do
      post '/api/links'
      expect(last_response.status).to eq 401
    end

    it 'returns 400 if link is not available' do
      @user = double(:user, id: 1, username: 'test', email: 'test@test')
      @link_hash = { id: 1, user_id: 1, valid?: false }
      @link = double(:link, @link_hash)
      @encoded_token = Token.new({ user_id: 1 }).encode
      @url = 'http://example.com'

      allow(User).to receive(:[]).and_return(@user)
      allow(Link).to receive(:new).and_return(@link)
      header 'AUTHENTICATION', "Bearer #{@encoded_token}"
      post '/api/links', { url: 'http://example.com' }.to_json

      expect(last_response.status).to eq 400
      expect(last_response.body).to eq({
        url: 'http://example.com',
        link: nil
      }.to_json)
    end

    it 'returns 409 if link already there' do
      @user = double(:user, id: 1, username: 'test', email: 'test@test')
      @link_hash = { id: 1, user_id: 1, valid?: true }
      @link = double(:link, @link_hash)
      @encoded_token = Token.new({ user_id: 1 }).encode
      @url = 'http://example.com'

      allow(User).to receive(:[]).and_return(@user)
      allow(Link).to receive(:[]).and_return(@link)
      allow(@link).to receive(:to_hash).and_return(@link_hash)
      allow(@link).to receive(:screenshot_uuid).and_return('')

      header 'AUTHENTICATION', "Bearer #{@encoded_token}"
      post '/api/links', { url: 'http://example.com' }.to_json

      expect(last_response.status).to eq 409
      expect(last_response.body).to eq({
        url: 'http://example.com',
        link: @link_hash
      }.to_json)
    end

    it 'creates and returns the link on auth' do
      @user = double(:user, id: 1, username: 'test', email: 'test@test')
      @link_hash = { id: 1, user_id: 1, valid?: true }
      @link = double(:link, @link_hash)
      @encoded_token = Token.new({ user_id: 1 }).encode

      allow(User).to receive(:[]).and_return(@user)
      allow(Link).to receive(:[]).and_return(nil)
      allow(Link).to receive(:create).and_return(@link)
      allow(LinkService).to receive(:get_hash).and_return(@link_hash)

      header 'AUTHENTICATION', "Bearer #{@encoded_token}"
      post '/api/links', { url: 'http://example.com' }.to_json

      expect(last_response).to be_ok
      expect(last_response.body).to eq({
        url: 'http://example.com',
        link: @link_hash
      }.to_json)
    end
  end

  describe 'delete_link' do
    it 'returns 401 when no auth' do
      delete '/api/links/1'
      expect(last_response.status).to eq 401
    end

    it 'returns 404 if link is not found' do
      @user = double(:user, id: 1, username: 'test', email: 'test@test')
      @encoded_token = Token.new({ user_id: 1 }).encode

      allow(User).to receive(:[]).and_return(@user)
      allow(Link).to receive(:[]).and_return(nil)

      header 'AUTHENTICATION', "Bearer #{@encoded_token}"
      delete '/api/links/1'

      expect(last_response.status).to eq 404
    end

    it 'deletes and returns the link on auth' do
      @user = double(:user, id: 1, username: 'test', email: 'test@test')
      @link_hash = { id: 1, user_id: 1 }
      @link = double(:link, @link_hash)
      @encoded_token = Token.new({ user_id: 1 }).encode

      allow(User).to receive(:[]).and_return(@user)
      allow(Link).to receive(:[]).and_return(@link)
      allow(@link).to receive(:to_hash).and_return(@link_hash)
      allow(@link).to receive(:screenshot_uuid).and_return('')
      allow(@link).to receive(:destroy).and_return(true)

      header 'AUTHENTICATION', "Bearer #{@encoded_token}"
      delete '/api/links/1'

      expect(last_response).to be_ok
      expect(last_response.body).to eq({ link: @link_hash }.to_json)
    end
  end

  describe 'bource_link' do
    it 'returns 404 when not found' do
    end

    it 'redirects without auth' do
      @link_hash = { id: 1, user_id: 1, url: 'http://example.com/' }
      @link = double(:link, @link_hash)
      allow(Link).to receive(:[]).and_return(@link)
      allow(@link).to receive(:update)
      allow(@link).to receive(:bounce).and_return(0)

      get '/links/bounce/1'

      expect(last_response).to be_redirect
      follow_redirect!
      expect(last_request.url).to eq @link_hash[:url]
    end
  end
end
