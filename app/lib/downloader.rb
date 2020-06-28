require "open-uri"

class Downloader
  def initialize(url)
    @url = url
  end

  def open
    Kernel.open(@url)
  end
end
