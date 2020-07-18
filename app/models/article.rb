class Article < ApplicationRecord
  def source
    host = URI(url).host
    return "Boston Globe" if /bostonglobe.com/ =~ host
    host
  end
end
