class Importer::CrimeIncidentReports
  SLICE_SIZE = 500

  def self.import_all
    parser = Parser::CrimeIncidentReports.new("data/tmpqy9o_jgd.csv")
    import(parser.records)
  end

  def self.import(records)
    records.each_slice(SLICE_SIZE) do |slice|
      Incident.transaction do
        import_slice(slice)
      end
    end
  end

  private
  def self.import_slice(slice)
    numbers = slice.pluck(:incident_number).map { |n| parse_incident_number(n) }.compact
    by_number = Hash.new { |h,k| h[k] = Incident.new }
    by_number.merge!(
      Incident.where(incident_number: numbers).index_by(&:incident_number)
    )

    slice.each do |record|
      attr = map_record(record)
      if attr[:incident_number]
        incident = by_number[attr[:incident_number]]
        incident.attributes = attr
        add_offense(incident, record)
      end
    end

    by_number.values.each(&:save)
  end

  def self.map_record(record)
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

  def self.parse_incident_number(str)
    subbed = str.sub(/^I/, "").sub(/-\d\d$/, "")
    if /^\d{7,}$/ =~ subbed
      subbed.to_i
    else
      nil
    end
  end

  def self.add_offense(incident, record)
    mapped = map_offense(record)
    present = incident.offenses.to_a.any? do |o|
      o.code == mapped[:code] &&
        o.code_group == mapped[:code_group] &&
        o.description == mapped[:description]
    end

    if !present
      incident.offenses << Offense.new(mapped)
    end
  end

  def self.map_offense(record)
    {
      code: record[:offense_code].to_i,
      code_group: parse_string(record[:offense_code_group]),
      description: parse_string(record[:offense_description])
    }
  end

  def self.parse_string(value)
    value.blank? ? nil : value
  end
end
