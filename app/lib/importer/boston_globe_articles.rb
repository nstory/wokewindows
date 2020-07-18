class Importer::BostonGlobeArticles
  SLICE = 200

  def initialize(path)
    @path = path
  end

  def self.import_all
    new("data/globe_articles").import
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
    url_hash = Article.where(url: docs.map { |doc| map_url(doc) }).index_by(&:url)

    docs.each do |doc|
      body = map_body(doc)
      url = map_url(doc)

      # don't import if it already exists
      next if url_hash[url]

      # only import if it's about BPD
      if /boston police/i =~ body
        Article.create(
          url: url,
          title: map_title(doc),
          date_published: map_date(doc),
          body: body
        )
      end
    rescue ActiveRecord::RecordNotUnique
      # ignore
    end
  end

  def map_body(doc)
    doc.css(".article-body, article").text.strip
  end

  def map_date(doc)
    url = map_url(doc)
    %r{(\d{4})/(\d{2})/(\d{2})}.match(url)
    return "#{$1}-#{$2}-#{$3}"
  end

  def map_title(doc)
    doc.css("title").text.sub(/-.*/, "").strip
  end

  def map_url(doc)
    doc.css('meta[property=\"og\\:url\"]').attr("content").to_s
  end

  def records
    Dir.glob("#{@path}/**/*").lazy
      .select { |f| File.file?(f) }
      .map { |f| IO.read(f) }
  end
end
