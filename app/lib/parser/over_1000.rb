# parses the suffolk county over $1,000 forfeiture files
class Parser::Over1000 < Parser::Parser
  def category
    "da_forfeitures"
  end

  def records
    lines = IO.read(@filename).each_line
    lines.map do |line|
      parse_line(line)
    end
  end

  private
  def parse_line(line)
    record = {}
    # 2012 file has a crazy unicode hyphen wtf
    # matches old-style: 01-4678 and new style 1207CR005835
    record[:case_number] = match(line.sub("\u2010", "-"), /((\d{2,4}-\d{4,6})|(\d{2}-?\d{2}\w\w\d{4,6}))/)
    record[:amount] = match(line, /(\$[\d,.]+)/)
    record[:police_report_number] = line.scan(/\d{9}/)
    record[:date] = match(line, %r[(\d{1,2}/\d{1,2}/\d{2,4})])
    record[:motor_vehicle] = match(line, /\$[\d,.]+ +(\d{4} [\w ]+?)  /   )
    record
  end

  def match(line, pattern)
    if pattern.match(line)
      return $1.strip
    end
    ""
  end
end
