module AvailabilityService
  def self.available?(url)
    begin
      uri = URI.parse(url)
    rescue
      return false
    end
    req = Net::HTTP.new(uri.host, uri.port)
    req.use_ssl = true if uri.scheme == 'https'
    begin
      res = req.request_head(uri)
      res.is_a?(Net::HTTPRedirection) || res.is_a?(Net::HTTPSuccess)
    rescue
      false
    end
  end
end
