require 'faraday'
require 'multi_json'

list_links = lambda do
  content_type :json

  page = params[:page].to_i || 0
  MultiJson.dump(
    links: Link.where(user_id: current_user.id)
               .order(Sequel.desc(:created_at))
               .limit(20, page * 20)
               .to_a
               .map { |link| LinkService.get_hash(link) }
  )
end

get_link = lambda do |id|
  content_type :json

  link = Link[user_id: current_user.id, id: id]
  halt 404, { link: nil }.to_json if link.nil?

  MultiJson.dump(link: LinkService.get_hash(link))
end

post_link = lambda do
  content_type :json

  url = @body_json[:url]
  link = Link[user_id: current_user.id, url: url]

  halt 409, { url: url, link: LinkService.get_hash(link) }.to_json if link

  meta = MetaService.fetch_meta(url)
  screenshot = ScreenshotService.fetch_screenshot(url)
  link = Link.create(
    [{ created_at: Time.now.utc, user_id: current_user.id }, meta, screenshot]
      .reduce({}) { |m, obj| m.merge(obj) }
  )
  MultiJson.dump(url: url, link: LinkService.get_hash(link))
end

delete_link = lambda do |id|
  content_type :json

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
get '/api/links/:id', &get_link
post '/api/links', &post_link
delete '/api/links/:id', &delete_link

get '/links/bounce/:id', &bounce_link
