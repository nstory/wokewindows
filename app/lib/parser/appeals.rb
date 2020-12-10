class Parser::Appeals < Parser::Parser
  def category
    "appeals"
  end

  def records
    Enumerator.new do |y|
      Zlib::GzipReader.open(@filename) do |gz|
        gz.each_line do |line|
          y << JSON.parse(line, symbolize_names: true)
        end
      end
    end
  end
end
