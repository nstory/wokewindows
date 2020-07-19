class Importer::Article::BayStateBanner < Importer::Article::Article
  def self.import_all
    new("data/banner_articles").import
  end

  def map_body(doc)
    doc.css("div.c").text
  end

  def map_title(doc)
    doc.css("title").first.text.sub(/ - The Bay State Banner/, "")
  end

  def map_url(doc)
    doc.css("div.on a").first.attr("href").to_s
  end
end
