# base class for parsers
class Parser::Parser
  def initialize(filename, category = nil)
    @filename = filename
    @category = category
  end

  def attribution
    Attribution.new(filename: pathname.basename.to_s.sub(/\.gz$/, ""), category: category, url: url)
  end

  def category
    raise "no category set" unless @category
    @category
  end

  def pathname
    Pathname.new(@filename)
  end

  def url
    nil
  end
end
