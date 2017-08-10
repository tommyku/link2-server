require 'metainspector'

module MetaService
  def self.fetch_meta(url)
    page = MetaInspector.new(url)
    {
      title: page.best_title,
      details: page.best_description,
      url: url
    }
  end
end
