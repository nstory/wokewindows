class Parser::LegacyCrimeIncidentReports < Parser::Csv
  MAPPING = {
    compnos: :incident_number,
    incident_type_description: :offense_description,
    reptdistrict: :district,
    reportingarea: :reporting_area,
    fromdate: :occurred_on_date,
    ucrpart: :ucr_part,
    streetname: :street
  }

  def category
    "legacy_crime_incident_reports"
  end

  def map_key(key)
    MAPPING.fetch(key, key)
  end
end
