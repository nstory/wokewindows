class Importer::Importer
  def initialize(parser)
    @parser = parser
  end

  private
  def attribution
    @parser.attribution
  end

  def incidents_by_number(numbers)
    by_number = Hash.new { |h,k| h[k] = Incident.new }
    by_number.merge!(
      Incident.where(incident_number: numbers).index_by(&:incident_number)
    )
    by_number
  end

  def complaints_by_number(numbers)
    by_number = Hash.new { |h,k| h[k] = Complaint.new }
    by_number.merge!(Complaint.by_ia_number(numbers))
    by_number
  end

  def parse_date(date)
    time = Chronic.parse(date)
    time ? time.strftime("%F") : nil
  end

  def parse_date_time(date)
    time = Chronic.parse(date)
    time ? time.strftime("%F %T") : nil
  end

  def parse_incident_number(str)
    subbed = str.sub(/^I/, "").sub(/-\d\d$/, "")
    if /^\d{7,}$/ =~ subbed
      subbed.to_i
    else
      nil
    end
  end

  def parse_int(str)
    str.blank? ? nil : str.to_i
  end

  def parse_string(str)
    str.blank? ? nil : str
  end

  def parse_nullable_int(value)
    (value == "NULL" || value.blank?) ? nil : value.to_i
  end

  def parse_nullable_string(value)
    (value == "NULL" || value.blank?) ? nil : value
  end

  def parse_money(money)
    money = money.gsub(/[^\d.]/, "")
    if /^\d+\.\d\d$/ =~ money
      money.to_f
    else
      0
    end
  end

  def parse_boolean(str)
    return true if /y/i =~ str
    return false if /n/i =~ str
    nil
  end

  def records
    @parser.records
  end
end
