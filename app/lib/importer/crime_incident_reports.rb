class Importer::CrimeIncidentReports < Importer::Importer

  SLICE_SIZE = 500

  def self.import_all
    parser = Parser::CrimeIncidentReports.new(
      "data/crime_incidents_reports_20200621.csv"
    )
    new(parser).import
  end

  def import
    records.each_slice(SLICE_SIZE) do |slice|
      Incident.transaction do
        import_slice(slice)
      end
    end
  end

  private
  def import_slice(slice)
    numbers = slice.pluck(:incident_number)
      .map { |n| parse_incident_number(n) }.compact
    by_number = incidents_by_number(numbers)

    slice.each do |record|
      attr = map_record(record)
      if attr[:incident_number]
        incident = by_number[attr[:incident_number]]
        incident.attributes = attr
        incident.add_offense(map_offense(record))
        incident.add_attribution(attribution)
      end
    end

    by_number.values.each(&:save)
  end

  def map_record(record)
    {
      incident_number: parse_incident_number(record[:incident_number]),
      district: parse_string(record[:district]),
      reporting_area: record[:reporting_area],
      shooting: ["Y", "1"].include?(record[:shooting]),
      occurred_on_date: record[:occurred_on_date],
      ucr_part: parse_string(record[:ucr_part]),
      street: parse_string(record[:street]),
      latitude: record[:lat],
      longitude: record[:long]
    }
  end

  def map_offense(record)
    Offense.new(
      code: record[:offense_code].to_i,
      code_group: parse_string(record[:offense_code_group]),
      description: parse_string(record[:offense_description])
    )
  end
end
