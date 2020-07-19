class Importer::Article::Wgbh < Importer::Article::Article
  def self.import_all
    new("data/wgbh_articles").import
  end

  def map_body(doc)
    doc.css(".RichTextArticleBody-body").text
  end
end
