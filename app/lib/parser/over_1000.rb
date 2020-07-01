class Parser::Over1000 < Parser::Parser
  def category
    "forfeitures_over_1000"
  end

  def records
    lines = IO.read(@filename).each_line.to_a[1..-1]
    lines.map do |line|
      parse_line(line)
    end
  end

  private
  def parse_line(line)
    record = {}
    record[:sucv] = match(line, /^([\w-]+)/)
    record[:amount] = match(line, /(\$[\d,.]+)/)
    record[:police_report_number] = line.scan(/\d{9}/) # match(line, /(\[[\d, -]+)/)
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
