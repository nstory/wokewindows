class Article < ApplicationRecord
  has_many :articles_officers

  def source
    host = URI(url).host
    return "Boston Globe" if /bostonglobe.com/ =~ host
    host
  end
end
