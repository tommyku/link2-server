class Link < Sequel::Model(:links)
  def_column_accessor :title
  def_column_accessor :details
  def_column_accessor :url
  def_column_accessor :tags
  def_column_accessor :screenshot_uuid
end
