class Parser::Swat < Parser::Parser
  DATE_MAPPING = {
    "12-10-120229050-APR23.txt" => "2012-04-23",
    "11-21-xxxx-aug18.txt" => "2011-08-18",
    "588206.txt" => "2013-09-06"
  }

  def category
    "swat"
  end

  def records
    [record]
  end

  private
  def record
    {
      swat_id: pathname.basename(".txt").to_s,
      date: parse_date,
      officers: parse_officers,
      incident_numbers: parse_incident_numbers
    }
  end

  # anything that looks like a nine-digit incident number
  def parse_incident_numbers
    IO.read(@filename).scan(/\b[12]\d-?\d{7}\b/)
  end

  # grab the first date-looking thing
  def parse_date
    bn = pathname.basename.to_s
    if DATE_MAPPING[bn]
      return DATE_MAPPING[bn]
    end
    if (/^(1\d)-\d+([a-z]+)(\d+)/i).match(bn)
      d = Chronic.parse("#{$2} #{$3}, #{$1}")
      return d.strftime("%F") if d
    end
    match = IO.read(@filename).match(%r{\b\d{1,2}/\d{1,2}/20[01]\d\b})
    return match ? match[0] : ""
  end

  def parse_officers
    IO.read(@filename).each_line.map do |line|
      if /^(.+)\b(\d{4,6})\b/ =~ line
        rec = {employee_id: $2, name: $1}
        rec[:name] = normalize_name(rec[:name])
        officer = by_employee_id[rec[:employee_id].to_i]
        if officer && officer.last_name_regexp =~ rec[:name]
          rec
        else
          nil
        end
      else
        nil
      end
    end.compact
  end

  def normalize_name(name)
    name = name.sub(/^[^a-z]*/i, "")
    name = name.sub(/[^a-z]*$/i, "")
    name
  end

  def by_employee_id
    @by_employee_id ||= Officer.by_employee_id
  end
end
