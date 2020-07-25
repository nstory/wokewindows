class Article < ApplicationRecord
  has_many :articles_officers, dependent: :delete_all
  has_many :officers, through: :articles_officers

  validates :url, presence: true, format: {with: URI.regexp}
  validates :date_published, format: {with: /\A\d{4}-\d{2}-\d{2}\z/}, allow_nil: true
  validates :title, presence: true

  def source
    host = URI(url).host
    return "Boston Globe" if /bostonglobe.com/ =~ host
    return "Boston Herald" if /bostonherald.com/ =~ host
    return "Bay State Banner" if /npaper-wehaa.com/ =~ host
    return "WGBH" if /wgbh.org/ =~ host
    return "Pax Centurion" if /pax_centurion/ =~ url
    return "Boston Magazine" if /bostonmagazine.com/ =~ host
    return "WBUR" if /wbur\.org/ =~ host
    return "Harvard Crimson" if /thecrimson\.com/ =~ host
    host.sub(/^www\./, "")
  end
end
