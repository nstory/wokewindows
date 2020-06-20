# parses data/bpd_ia_data_2001_2011.txt which was exported from
# Copy-of-BPD-IA-Data-2001-2011-to-be-updated.pdf
class Parser::BpdIaData < Parser::Parser
  def category
    "bpd_ia_data_2001_2011"
  end

  def records
    page = []
    lines.each do |line|
      if /^(IA No.*First name|Last name.*number|Allega.*taken)$/ =~ line
        page << []
      else
        page.last << line
      end
    end

    (0 ... page[0].count).map do |i|
      parse_first(page[0][i]).merge(parse_second(page[1][i])).merge(parse_third(page[2][i]))
    end
  end

  private
  def parse_first(line)
    %r{^([^\s]+)\s+(\d+)?\s+(.+) (\d+/\d+/\d+)(.*)$}.match(line)
    {
      ia_no: $1,
      case_no: $2 || "",
      incident_type: $3.strip,
      received_date: $4,
      first_name: $5.strip
    }
  end

  def parse_second(line)
    badge_id_number = if /(\d+)$/.match(line)
      $1
    else
      ""
    end
    split = line.split(/ {2,}/)
    {
      last_name: split[0].strip,
      title: split[1].strip,
      badge_id_number: badge_id_number
    }
  end

  def parse_third(line)
    hash = {allegation: "", finding: "", finding_date: ""}

    if %r{\d{1,2}/\d{1,2}/\d{2,4}}.match(line)
      hash[:finding_date] = $&
    end

    if %r{^(.*)  \b(Pending|Converted|Filed|Resolved|Not Sustained|Sustained|Unfounded|Exonerated|Withdrawn|Referred to District)\b}.match(line)
      hash[:allegation] = $1
      hash[:finding] = $2
    end

    hash.map { |k,v| [k, v.strip] }.to_h
  end

  def lines
    IO.read(@filename).each_line.reject(&:blank?).map(&:strip)
  end
end
