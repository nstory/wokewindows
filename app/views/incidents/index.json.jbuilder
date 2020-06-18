# vi: ft=ruby
json.draw  params[:draw].to_i
json.recordsTotal @records_total
json.recordsFiltered @records_filtered
json.incidents @incidents do |incident|
  json.incident_number incident.incident_number
  json.occurred_on_date incident.occurred_on_date
  json.district incident.district
  json.reporting_area incident.reporting_area
  json.shooting incident.shooting
  json.location incident.location
  json.location_of_occurrence incident.location_of_occurrence
  json.street incident.street
  json.report_date incident.report_date
  json.nature_of_incident incident.nature_of_incident

  json.incident_officers(incident.incident_officers) do |io|
    json.url(io.officer ? officer_path(io.officer) : nil)
    json.name io.employee_name
  end

  json.arrests(incident.arrests) do |arrest|
    json.name arrest.name
    json.charge arrest.charge
  end

  json.offenses(incident.offenses) do |offense|
    json.code offense.code
    json.code_group offense.code_group
    json.description offense.description
  end
end
