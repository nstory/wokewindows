class ArticleFetcher
  def initialize(url)
    @url = url
    @officer_matcher = OfficerMatcher.new
  end

  def fetch
    article = Article.new
    response = get(@url)
    return nil if !response
    doc = Nokogiri::HTML(response.body)
    article.body = parse_body(doc)
    article.title = parse_title(doc)
    article.url = parse_url(doc) || @url
    if %r{/(\d{4})/(\d{2})/(\d{2})/}.match(article.url)
      article.date_published = "#{$1}-#{$2}-#{$3}"
    end
    article.officers = @officer_matcher.matches(article.body)
    article
  end

  def parse_body(doc)
    e = doc.css("body").first
    e ? e.text.gsub(/\s+/, " ").strip : nil
  end

  def parse_title(doc)
    e = doc.css("title").first
    e ? e.text.strip : nil
  end

  def parse_url(doc)
    e = doc.css("meta[property='og:url']").first
    e ? e.attr("content") : nil
  end

  private
  def get(url)
    HTTParty.get(@url)
  rescue
    nil
  end
end
