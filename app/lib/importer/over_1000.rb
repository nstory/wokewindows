class Importer::Over1000 < Importer::Importer
  def self.import_all
    files = %w[
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
    return if attrs[:sucv].blank?
    f = Forfeiture.new(attrs)
    f.add_attribution attribution
    f.save
  rescue ActiveRecord::RecordNotUnique
    # ignore
  end

  def map_record(record)
    {
      sucv: record[:sucv],
      amount: parse_money(record[:amount]),
      date: parse_date(record[:date]),
      motor_vehicle: parse_string(record[:motor_vehicle]),
      forfeitures_incidents: parse_incidents(record[:police_report_number])
    }
  end

  def parse_incidents(arr)
    arr.map do |n|
      ForfeituresIncident.new(
        incident_number: n,
        incident: Incident.find_by(incident_number: n)
      )
    end
  end
end
