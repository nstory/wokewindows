class Importer::Article::Crimson < Importer::Article::Article
  def self.import_all
    new("data/crimson_articles").import
  end

  def map_body(doc)
    doc.css(".css-1hc0jhf").first.text
  end

  def map_title(doc)
    doc.css('meta[property="og:title"]').attr("content").to_s.sub(/ \|.*/, "")
  end

  def map_url(doc)
    doc.css('meta[property="og:url"]').attr("content").to_s
  end
end
