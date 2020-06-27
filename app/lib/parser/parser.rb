# base class for parsers
class Parser::Parser
  def initialize(filename)
    @filename = filename
  end

  def attribution
    Attribution.new(filename: pathname.basename.to_s.sub(/\.gz$/, ""), category: category, url: url)
  end

  def pathname
    Pathname.new(@filename)
  end

  def url
    nil
  end
end
