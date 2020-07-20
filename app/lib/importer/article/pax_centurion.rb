# lots of copy-and-pasting from Importer::Article:Article b/c
# these are weird and the only non-HTML articles
class Importer::Article::PaxCenturion
  SLICE = 200

  def self.import_all
    new("data/pax_centurion").import
  end

  # path is a directory containing html files (possibly in nested
  # sub-directories)
  def initialize(path)
    @path = path
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
    urls = slice.map { |r| map_url(r) }
    by_url = Hash.new { |h,k| h[k] = Article.new }
    by_url.merge!(
      Article.where(url: urls).index_by(&:url)
    )

    slice.each do |pn|
      url = map_url(pn)
      article = by_url[url]
      article.attributes = {
        url: url,
        title: map_title(pn),
        body: map_body(pn),
        date_published: map_date_published(pn)
      }
      article.save
    end
  end

  def records
    Dir.glob("#{@path}/**/*").lazy
      .select { |f| File.file?(f) }
      .map { |f| Pathname.new(f) }
  end

  def map_body(pn)
    pn.read
  end

  def map_date_published(pn)
    year = /\d{4}/.match(pn.basename.to_s)[0]
    "#{year}-01-01"
  end

  def map_title(pn)
    filename = pn.basename.to_s
    name = filename.sub(/_\d+\.txt/, "").strip.titleize
    "#{name} - Page #{page_number(pn)}"
  end

  def map_url(pn)
    "https://wokewindows-data.s3.amazonaws.com/pax_centurion_issues/" + pn.basename.to_s.sub(/_\d+.txt/, ".pdf") + "#page=" + page_number(pn)
  end

  def page_number(pn)
    filename = pn.basename.to_s
    /(\d+)\.txt$/.match(filename)[1]
  end
end
