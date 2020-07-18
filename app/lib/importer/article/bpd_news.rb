class Importer::Article::BpdNews < Importer::Article::Article
  def self.import_all
    new("data/bpd_news_articles").import
  end

  private
  def records
    Dir.glob("#{@path}/*.html").lazy.map { |f| IO.read(f) }
  end

  def map_body(doc)
    doc.css("div.body").first.text.gsub(/\n[\n\s]+/m, "\n\n").strip
  end

  def map_date_published(doc)
    doc.css("time.published").attr("datetime")
  end

  def map_url(doc)
    href = doc.css("h1.entry-title a").attr("href").value
    URI.join("https://bpdnews.com", href).to_s
  end

  def map_title(doc)
    doc.css("h1.entry-title").first.text
  end
end
