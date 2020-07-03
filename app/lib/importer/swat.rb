class Importer::Swat < Importer::Importer
  def self.import_all
    Dir.glob("data/swats/*.txt") do |filename|
      p = Parser::Swat.new(filename)
      new(p).import
    end
  end

  def import
    record = records.first # each swat parser only parses one record
    swat = Swat.new({
      swat_number: record[:swat_id],
      date: parse_date(record[:date]),
      swats_officers: map_officers(record[:officers]),
      swats_incidents: map_incidents(record[:incident_numbers])
    })
    swat.add_attribution(attribution)
    swat.save!
  rescue ActiveRecord::RecordNotUnique
    # ignore
  end

  private
  def map_incidents(incidents)
    incidents.map do |i|
      SwatsIncident.new({
        incident_number: i,
        incident: Incident.find_by(incident_number: i.gsub(/[^\d]/, ""))
      })
    end.uniq { |o| o.incident_id }
  end

  def map_officers(officers)
    officers.map do |o|
      SwatsOfficer.new({
        officer_name: o[:name],
        officer: Officer.find_by(employee_id: o[:employee_id])
      })
    end.uniq { |o| o.officer_id }
  end
end
