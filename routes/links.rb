require 'faraday'
require 'multi_json'

list_links = lambda do
  page = params[:page].to_i || 0
  MultiJson.dump(links: LinkService.get_collection(current_user.id, page))
end

list_random_links = lambda do
  MultiJson.dump(links: LinkService.get_random_collection(current_user.id, 10))
end

get_link = lambda do |id|
  link = Link[user_id: current_user.id, id: id]
  halt 404, { link: nil }.to_json if link.nil?

  MultiJson.dump(link: LinkService.get_hash(link))
end

post_link = lambda do
  url = @body_json[:url]
  link = Link[user_id: current_user.id, url: url]

  halt 409, { url: url, link: LinkService.get_hash(link) }.to_json if link

  link = Link.new({ created_at: Time.now.utc, user_id: current_user.id, url: url })

  halt 400, { url: url, link: nil }.to_json unless link.valid?

  meta = MetaService.fetch_meta(url)
  link.set(meta)
  screenshot = ScreenshotService.fetch_screenshot(url)
  link.set(screenshot)
  MultiJson.dump(url: url, link: LinkService.get_hash(link))
end

delete_link = lambda do |id|
  link = Link[user_id: current_user.id, id: id]
  halt 404, { link: nil }.to_json if link.nil?

  link.destroy
  MultiJson.dump(link: LinkService.get_hash(link))
end

bounce_link = lambda do |id|
  link = Link[id]
  halt 404, { link: nil }.to_json if link.nil?

  link.update(bounce: link.bounce + 1)

  redirect link.url
end

get '/api/links', &list_links
get '/api/links/random', &list_random_links
get '/api/links/:id', &get_link
post '/api/links', &post_link
delete '/api/links/:id', &delete_link

get '/links/bounce/:id', &bounce_link
