require 'sinatra'
require 'faraday'
require 'multi_json'

get '/api/links' do
  content_type :json

  page = params[:page].to_i || 0
  {
    links: Link.order(Sequel.desc(:created_at))
               .limit(20, page * 20)
               .to_a
               .map(:to_hash)
  }.to_json
end

get '/api/links/:id' do |id|
  content_type :json

  link = Link[id]
  if link.nil?
    status(404)
    { link: nil }.to_json
  else
    { link: link.to_hash }.to_json
  end
end

post '/api/links' do
  content_type :json

  url = @body_json[:url]
  if Link.where(url: url).any?
    status(409)
    { url: url, link: nil }.to_json
  else
    meta = MetaService.fetch_meta(url)
    screenshot = ScreenshotService.fetch_screenshot(url)
    link = Link.create(
      [{ created_at: Time.now.utc }, meta, screenshot]
        .reduce({}) { |m, obj| m.merge(obj) }
    )
    { url: url, link: link.to_hash }.to_json
  end
end

delete '/api/links/:id' do |id|
  content_type :json

  link = Link[id]
  if link.nil?
    status(404)
    { link: nil }.to_json
  else
    link.destroy
    { link: link.to_hash }.to_json
  end
end
