module LinkService
  def self.get_hash(link)
    link.to_hash.tap do |h|
      h[:screenshot_url] = "/screenshots/#{link.screenshot_uuid}.jpg"
    end
  end
end
