class Importer::Forfeiture::Forfeiture < Importer::Importer
  def self.import_all
    files = {
      "data/over_1000_2012.txt" => Importer::Forfeiture::Superior,
      "data/over_1000_2013.txt" => Importer::Forfeiture::Superior,
      "data/over_1000_2014.txt" => Importer::Forfeiture::Superior,
      "data/over_1000_2015.txt" => Importer::Forfeiture::Superior,
      "data/DC_Dorchester_Redacted.txt" => Importer::Forfeiture::BmcDorchester,
      "data/DC_Roxbury_Redacted.txt" => Importer::Forfeiture::BmcRoxbury,
      "data/DC_Boston_Municipal_Court_Redacted.txt" => Importer::Forfeiture::BmcCentral,
      "data/DC_West_Roxbury_Redacted.txt" => Importer::Forfeiture::BmcWestRoxbury,
      "data/DC_East_Boston_Redacted.txt" => Importer::Forfeiture::BmcEastBoston,
      "data/DC_Brighton_Redacted.txt" => Importer::Forfeiture::BmcBrighton,
      "data/DC_Charlestown_Redacted.txt" => Importer::Forfeiture::BmcCharlestown,
    }
    files.each do |file, importer|
      parser = Parser::Over1000.new(file)
      importer.new(parser).import
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
      case_number: parse_case_number(record[:case_number]),
      court: court,
      amount: parse_money(record[:amount]),
      date: parse_forfeiture_date(record[:date]),
      motor_vehicle: parse_string(record[:motor_vehicle]),
      cases_incidents: parse_incidents(record[:police_report_number])
    }
  end

  def parse_incidents(arr)
    arr.map do |n|
      CasesIncident.new(
        incident_number: n,
        incident: Incident.find_by(incident_number: n)
      )
    end
  end

  def parse_forfeiture_date(date)
    time = Chronic.parse(date)
    return nil if !time
    # we only have data for 2001-2015
    return nil if time.year < 2001 || time.year > 2015
    time ? time.strftime("%F") : nil
  end
end
