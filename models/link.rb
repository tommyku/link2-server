class Link < Sequel::Model(:links)
  plugin :validation_helpers

  def_column_accessor :title
  def_column_accessor :details
  def_column_accessor :url
  def_column_accessor :tags
  def_column_accessor :screenshot_uuid
  def_column_accessor :bounce
  def_column_accessor :created_at

  def validate
    super
    validates_presence :url
    validates_format /\Ahttps?:\/\//, :url, allow_blank: false
    errors.add(:url, 'is not available') unless AvailabilityService.available?(url)
  end
end
