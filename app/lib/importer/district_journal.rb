class Importer::DistrictJournal < Importer::Importer

  JOURNALS = "pdfs/*.pdf"
  SLICE_SIZE = 500

  def self.import_all
    files = Dir.glob(JOURNALS)
    files.each do |f|
      parser = Parser::DistrictJournal.new(f)
      new(parser).import if parser.likely_journal?
    end
  end

  def import
    records.each_slice(SLICE_SIZE) do |slice|
      Incident.transaction do
        import_slice(slice)
      end
    end
  end

  def import_slice(slice)
    by_number = incidents_by_number(
      slice.pluck(:complaint_number).map { |n| parse_incident_number(n) }
    )

    slice.each do |record|
      attrs = map_record(record)
      next if !attrs[:incident_number]
      inc = by_number[attrs[:incident_number]]
      inc.attributes = attrs
      add_to_array(inc, :location_of_occurrence, parse_string(record[:location_of_occurrence]))
      add_to_array(inc, :nature_of_incident, parse_string(record[:nature_of_incident]))
      record[:arrests].each do |arrest|
        add_to_array(inc, :arrests_json, parse_arrest(arrest))
      end
      add_officer(inc, record[:officer])
      inc.add_attribution(attribution)
    end

    by_number.values.each(&:save)
  end

  def map_record(record)
    {
      incident_number: parse_incident_number(record[:complaint_number]),
      occurred_on_date: parse_date(record[:occurrence_date_time]),
      report_date: parse_date(record[:report_date_time])
    }
  end

  def add_to_array(incident, field, item)
    return if item.blank?
    current = (incident.send(field) || [])
    return if current.include?(item)
    incident.attributes = {field => (current + [item])}
  end

  def add_officer(incident, journal_name)
    return if journal_name.blank?
    current = incident.incident_officers.map(&:journal_officer)
    return if current.include?(journal_name)
    incident.incident_officers << IncidentOfficer.new(journal_officer: journal_name)
  end

  def parse_arrest(arrest)
    return nil if /^\d/ =~ arrest[:name] # probably a misplaced address
    a = Arrest.new({name: arrest[:name], charge: arrest[:charge]})
    a.redact!
    a.as_json
  end

  def parse_date(date)
    time = Chronic.parse(date)
    time ? time.strftime("%F %T") : nil
  end
end
