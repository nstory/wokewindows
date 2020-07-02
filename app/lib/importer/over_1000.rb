class Importer::Over1000 < Importer::Importer
  def self.import_all
    files = %w[
      data/over_1000_2012.txt
      data/over_1000_2013.txt
      data/over_1000_2014.txt
      data/over_1000_2015.txt
    ]
    files.each do |file|
      parser = Parser::Over1000.new(file)
      new(parser).import
    end
  end

  def import
    records.each do |record|
      import_record(record)
    end
  end

  private
  def import_record(record)
    attrs = map_record(record)
    return if attrs[:case_number].blank?
    f = Case.new(attrs)
    f.add_attribution attribution
    f.save!
  rescue ActiveRecord::RecordNotUnique
    # ignore
  end

  def map_record(record)
    {
      case_number: parse_case_number(record[:sucv]),
      court: "superior",
      amount: parse_money(record[:amount]),
      date: parse_date(record[:date]),
      motor_vehicle: parse_string(record[:motor_vehicle]),
      cases_incidents: parse_incidents(record[:police_report_number])
    }
  end

  def parse_case_number(sucv)
    if /^(\d{4})-(\d+)/.match(sucv)
      year = $1
      num = $2
      return "#{year.to_i - 2000}84CV#{num.rjust(5, "0")}"
    end

    if sucv.gsub("-", "").length == 11
      return sucv.gsub("-", "")
    end

    nil
  end

  def parse_incidents(arr)
    arr.map do |n|
      CasesIncident.new(
        incident_number: n,
        incident: Incident.find_by(incident_number: n)
      )
    end
  end
end
