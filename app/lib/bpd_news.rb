class BpdNews
  def initialize(base_url =  "https://bpdnews.com")
    @base_url = base_url
  end

  def articles
    Enumerator.new do |y|
      get_pages.each do |page|
        articles = page.parsed.xpath("//article")
        articles.each { |a| y << a }
      end
    end
  end

  def pdfs
    url = @base_url
    Enumerator.new do |y|
      while url
        links = get_links(url)
        pdf_links = links.select { |l| /\.pdf$/i =~ l }
        pdf_links.each { |l| y << l }
        url = next_url(links)
      end
    end
  end

  private
  def get_articles(url)
    Rails.logger.info "get_articles #{url}"
    page = nil
    retry_it { page = get_page(url) }
    page.parsed.xpath("//article")
  end

  def get_links(url)
    Rails.logger.info "get_links #{url}"
    page = nil
    retry_it { page = get_page(url) }
    page.links.all.map do |l|
      URI.join(@base_url, l).to_s
    end
  end

  def get_pages
    url = @base_url
    Enumerator.new do |y|
      while url
        page = get_page(url)
        y << page
        links = page.links.all.map do |l|
          URI.join(@base_url, l).to_s
        end
        url = next_url(links)
      end
    end
  end

  def get_page(url)
    page = MetaInspector.new(url, download_images: false)
    raise "bad status" if page.response.status != 200
    page
  end

  def next_url(links)
    links.find { |l| l =~ /offset=\d+$/ }
  end

  def retry_it
    retries = 10
    begin
      yield
    rescue
      if retries > 0
        retries -= 1
        sleep 2
        retry
      else
        raise "retries exhausted"
      end
    end
  end
end
