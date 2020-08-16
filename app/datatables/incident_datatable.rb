class IncidentDatatable < ApplicationDatatable

  def view_columns
    @view_columns ||= {
      incident_number: {source: "Incident.incident_number", searchable: false},
      links: {searchable: false, orderable: false},
      occurred_on_date: {source: "Incident.occurred_on_date", searchable: false, nulls_last: true},
      district: {source: "Incident.district", searchable: false},
      shooting: {source: "Incident.shooting", searchable: false},
      location_of_occurrence: {source: "Incident.location_of_occurrence", searchable: false},
      street: {source: "Incident.street", searchable: false},
      nature_of_incident: {source: "Incident.nature_of_incident", searchable: false},
      offenses: {source: "Incident.offenses", searchable: false, orderable: false},
      officer_journal_name: {source: "Incident.officer_journal_name", searchable: false},
      incident_clearance: {source: "Incident.incident_clearance", searchable: false},
      number_of_arrestees: {source: "Incident.number_of_arrestees", searchable: false},
      number_of_victims: {source: "Incident.number_of_victims", searchable: false},
      number_of_offenders: {source: "Incident.number_of_offenders", searchable: false},
      bag_of_text: {source: "Incident.bag_of_text", searchable: true, orderable: false}
    }
  end

  def data_record(record)
    {
      url: incident_url(record),
      incident_number: record.incident_number,
      links: record.links?,
      occurred_on_date: record.occurred_on_date,
      district: record.district,
      district_name: record.district_name,
      shooting: record.shooting,
      location_of_occurrence: record.location_of_occurrence,
      street: record.street,
      nature_of_incident: record.nature_of_incident,
      officer_journal_name: record.officer_journal_name,
      offenses: record.offenses.map(&:description),
      incident_clearance: record.incident_clearance,
      number_of_arrestees: record.number_of_arrestees,
      number_of_victims: record.number_of_victims,
      number_of_offenders: record.number_of_offenders
    }
  end

  def get_raw_records
    q = Incident.includes(:field_contacts, :cases).all
    if params[:officer_id]
      q = q.where("officer_id" => params[:officer_id])
    end
    q
  end

end
