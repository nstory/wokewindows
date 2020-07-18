class Importer::Article::BostonHerald < Importer::Article::Article
  private
  def filter(doc)
    /boston\s+police/mi =~ map_body(doc)
  end

  def map_body(doc)
    doc.css(".article-body").text
  end
end
