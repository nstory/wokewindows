class Importer::Article::BostonHerald < Importer::Article::Article
  def self.import_all
    new("data/herald_articles").import
  end

  private
  def filter(doc)
    /boston\s+police/mi =~ map_body(doc)
  end

  def map_body(doc)
    doc.css(".article-body").text
  end
end
