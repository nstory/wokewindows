class Importer::BpdNewsArticles
  SLICE = 1000

  def initialize(path)
    @path = path
  end

  def self.import_all
    new("articles").import
  end

  def import
    records.each_slice(SLICE) do |slice|
      Article.transaction do
        import_slice(slice)
      end
    end
  end

  def import_slice(slice)
    docs = slice.map { |r| Nokogiri::HTML(r) }
    urls = docs.map { |r| map_url(r) }
    by_url = Hash.new { |h,k| h[k] = Article.new }
    by_url.merge!(
      Article.where(url: urls).index_by(&:url)
    )

    docs.each do |doc|
      article = by_url[map_url(doc)]
      article.attributes = {
        url: map_url(doc),
        title: map_title(doc),
        body: map_body(doc)
      }
      article.save
    end
  end

  private
  def records
    Dir.glob("#{@path}/*.html").lazy.map { |f| IO.read(f) }
  end

  def map_body(doc)
    doc.css("div.body").first.text.gsub(/\n[\n\s]+/m, "\n\n").strip
  end

  def map_url(doc)
    href = doc.css("h1.entry-title a").attr("href").value
    URI.join("https://bpdnews.com", href).to_s
  end

  def map_title(doc)
    doc.css("h1.entry-title").first.text
  end
end
