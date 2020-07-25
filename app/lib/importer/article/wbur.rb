class Importer::Article::Wbur < Importer::Article::Article
  def self.import_all
    new("data/wbur_articles").import
  end

  def map_body(doc)
    doc.css(".article-content, .article").first.text.strip
  end

  def map_title(doc)
    super(doc).sub(/ \| .*/, "")
  end

  def map_url(doc)
    doc.css('meta[property="og:url"]').attr("content").to_s # .sub(/ \| .*/, "")
  end
end
