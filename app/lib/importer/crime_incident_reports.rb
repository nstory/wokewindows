class Importer::CrimeIncidentReports < Importer::Importer

  SLICE_SIZE = 500

  def self.import_all
    import_legacy
    import_non_legacy
    import_nibrs
  end

  def self.import_legacy
      parser = Parser::LegacyCrimeIncidentReports.new("data/crime-incident-reports-july-2012-august-2015-source-legacy-system.csv.gz"),
      new(parser).import
  end

  def self.import_non_legacy
    parser = Parser::CrimeIncidentReports.new("data/crime_incident_reports.csv.gz")
    new(parser).import
  end

  def self.import_nibrs
    parser = Parser::NibrsIncidentReports.new("data/boston_nibrs_foia.csv.gz")
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
    is_nibrs = @parser.attribution.category.include?("nibrs")

    numbers = slice.pluck(:incident_number)
      .map { |n| parse_incident_number(n) }.compact
    by_number = incidents_by_number(numbers)

    slice.each do |record|
      attr = is_nibrs ? map_nibrs_record(record) : map_record(record)
      if attr[:incident_number]
        incident = by_number[attr[:incident_number]]
        incident.attributes = attr
        if is_nibrs
          incident.add_nibrs_offense(map_nibrs_offense(record))
        else
          incident.add_offense(map_offense(record))
        end
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
      reported_latitude: parse_location(record[:location])[:latitude],
      reported_longitude: parse_location(record[:location])[:longitude]
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

  private
  def map_nibrs_record(record)
    {
      incident_number: parse_incident_number(record[:incident_number]),
      location_type: parse_string(record[:location_type]),
      incident_clearance: parse_string(record[:incident_clearance]),
      exceptional_clearance_date: parse_string(record[:exceptional_clearance_date]),
      number_of_victims: parse_int(record[:number_of_victims_in_incident]),
      number_of_offenders: parse_int(record[:number_of_offenders_in_incident]),
      number_of_arrestees: parse_int(record[:number_of_arrestees_in_incident])
    }
  end

  private
  def map_nibrs_offense(record)
    mapped_offense = NibrsOffense.new(
        ucr_code: parse_string(record[:offense_code]),
        description: parse_string(record[:offense_type]),
        attempted_or_completed: parse_string(record[:attempted_or_completed]),
        number_of_crimes: parse_int(record[:number_of_crimes]),
        number_of_victims: parse_int(record[:number_of_victims]),
        number_of_stolen_vehicles: parse_int(record[:number_of_stolen_vehicles]),
        number_of_recovered_vehicles: parse_int(record[:number_of_recovered_vehicles]),
        method_of_entry: parse_string(record[:method_of_entry]),
        number_of_premises_entered: parse_int(record[:number_of_premises_entered])
    )
  end
end
