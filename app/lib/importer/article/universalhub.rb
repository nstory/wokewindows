class Importer::Article::Universalhub < Importer::Article::Article
  def self.import_all
    new("data/universalhub_articles").import
  end

  def map_body(doc)
    doc.css(".field-name-body").first.text.strip
  end

  def map_date_published(doc)
    elems = doc.css('span[property*="dc:date"]')
    return nil if elems.empty?
    elems.first.attr("content").sub(/T.*/, "")
  end

  def map_title(doc)
    super(doc).sub(/ \|.*/, "")
  end
end
