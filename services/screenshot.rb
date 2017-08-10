require 'faraday'

module ScreenshotService
  def self.fetch_screenshot(url)
    conn = connection
    payload = { url: url }
    response = conn.post('/screenshot', payload)
    { screenshot_uuid: response.status == 202 ? response.body : '' }
  end

  def self.connection
    Faraday.new(url: ENV['SCREENSHOT_SERVICE_URL'])
  end
end
