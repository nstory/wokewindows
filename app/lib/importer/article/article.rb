# base class for article importers
class Importer::Article::Article
  SLICE = 200

  # path is a directory containing html files (possibly in nested
  # sub-directories)
  def initialize(path)
    @path = path
  end

  def import
    records.each_slice(SLICE) do |slice|
      Article.transaction do
        import_slice(slice)
      end
    end
  end

  private
  def import_slice(slice)
    docs = slice.map { |r| Nokogiri::HTML(r) }
    urls = docs.map { |r| map_url(r) }
    by_url = Hash.new { |h,k| h[k] = Article.new }
    by_url.merge!(
      Article.where(url: urls).index_by(&:url)
    )

    docs.each do |doc|
      next unless filter(doc)
      url = map_url(doc)
      article = by_url[url]
      article.attributes = {
        url: url,
        title: map_title(doc),
        body: map_body(doc),
        date_published: map_date_published(doc)
      }
      article.save
    end
  end

  def records
    Dir.glob("#{@path}/**/*").lazy
      .select { |f| File.file?(f) }
      .map { |f| IO.read(f) }
  end

  def filter(doc)
    true
  end

  def map_date_published(doc)
    url = map_url(doc)
    %r{/(\d{4})/(\d{1,2})/(\d{1,2})/}.match(url)
    "%d-%02d-%02d" % [$1.to_i, $2.to_i, $3.to_i]
  end

  def map_title(doc)
    doc.css("title").first.text
  end

  def map_url(doc)
    doc.css('link[rel=canonical]').attr("href").to_s
  end
end
