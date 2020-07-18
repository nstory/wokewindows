class Importer::Article::BostonGlobe < Importer::Article::Article
  def self.import_all
    new("data/globe_articles").import
  end

  private
  def filter(doc)
    /boston\s+police/mi =~ map_body(doc)
  end

  def map_body(doc)
    doc.css(".article-body, article").text.strip
  end

  def map_title(doc)
    doc.css("title").first.text.sub(/- (The Boston Globe|Metro).*/im, "").strip
  end

  def map_url(doc)
    doc.css('meta[property=\"og\\:url\"]').attr("content").to_s
  end
end
