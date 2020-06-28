class Importer::CrimeIncidentReports < Importer::Importer

  SLICE_SIZE = 500

  def self.import_all
    import_legacy
    import_non_legacy
  end

  def self.import_legacy
      parser = Parser::LegacyCrimeIncidentReports.new("data/crime-incident-reports-july-2012-august-2015-source-legacy-system.csv.gz"),
      new(parser).import
  end

  def self.import_non_legacy
    parser = Parser::CrimeIncidentReports.new("data/crime_incident_reports.csv.gz")
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
      shooting: parse_boolean(record[:shooting]),
      occurred_on_date: parse_date_time(record[:occurred_on_date]),
      ucr_part: parse_string(record[:ucr_part]),
      street: parse_string(record[:street]),
      latitude: parse_location(record[:location])[:latitude],
      longitude: parse_location(record[:location])[:longitude]
    }
  end

  def map_offense(record)
    Offense.new(
      code: parse_int(record[:offense_code]),
      code_group: parse_string(record[:offense_code_group]),
      description: parse_string(record[:offense_description])
    )
  end

  private
  def parse_boolean(b)
    ["1", "Y", "Yes"].include?(b)
  end

  def parse_location(location)
    matches = /^\(([\d.-]+), ([\d.-]+)\)$/.match(location) || []
    h = { latitude: matches[1].to_f, longitude: matches[2].to_f }
    if h[:latitude] == 0 || h[:longitude] == 0
      return({ latitude: nil, longitude: nil })
    end
    h
  end
end
