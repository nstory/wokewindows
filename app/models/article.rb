class Article < ApplicationRecord
  def source
    URI(url).host
  end
end
