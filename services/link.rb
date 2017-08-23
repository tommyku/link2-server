module LinkService
  def self.get_hash(link)
    link.to_hash.tap do |h|
      h[:screenshot_url] = "/screenshots/#{link.screenshot_uuid}.jpg"
    end
  end

  def self.get_collection(user_id, page)
    Link.where(user_id: user_id)
        .order(Sequel.desc(:created_at))
        .limit(20, page * 20)
        .to_a
        .map { |link| get_hash(link) }
  end

  def self.get_random_collection(user_id, limit)
    Link.where(user_id: user_id)
        .order(Sequel.lit('RANDOM()'))
        .limit(limit)
        .to_a
        .map { |link| get_hash(link) }
  end
end
