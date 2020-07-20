class Article < ApplicationRecord
  has_many :articles_officers, dependent: :delete_all

  def source
    host = URI(url).host
    return "Boston Globe" if /bostonglobe.com/ =~ host
    return "Boston Herald" if /bostonherald.com/ =~ host
    return "Bay State Banner" if /npaper-wehaa.com/ =~ host
    return "WGBH" if /wgbh.org/ =~ host
    return "Pax Centurion" if /pax_centurion/ =~ url
    host
  end
end
