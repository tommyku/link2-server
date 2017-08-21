require 'sinatra'
require 'faraday'
require 'multi_json'

list_links = lambda do
  content_type :json

  page = params[:page].to_i || 0
  {
    links: Link.order(Sequel.desc(:created_at))
               .limit(20, page * 20)
               .to_a
               .collect(&:to_hash)
  }.to_json
end

get_link = lambda do |id|
  content_type :json

  link = Link[id]
  halt 404, { link: nil }.to_json if link.nil?

  { link: link.to_hash }.to_json
end

post_link = lambda do
  content_type :json

  url = @body_json[:url]
  link = Link.find(url: url)

  halt 409, { url: url, link: link.to_hash }.to_json if link

  meta = MetaService.fetch_meta(url)
  screenshot = ScreenshotService.fetch_screenshot(url)
  link = Link.create(
    [{ created_at: Time.now.utc }, meta, screenshot]
      .reduce({}) { |m, obj| m.merge(obj) }
  )
  { url: url, link: link.to_hash }.to_json
end

delete_link = lambda do |id|
  content_type :json

  link = Link[id]
  halt 404, { link: nil }.to_json if link.nil?

  link.destroy
  { link: link.to_hash }.to_json
end

get '/api/links', &list_links
get '/api/links/:id', &get_link
post '/api/links', &post_link
delete '/api/links/:id', &delete_link
