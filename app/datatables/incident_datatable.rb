class IncidentDatatable < ApplicationDatatable

  def view_columns
    @view_columns ||= {
      incident_number: {source: "Incident.incident_number", cond: :eq},
      occurred_on_date: {source: "Incident.occurred_on_date"},
      district: {source: "Incident.district"},
      shooting: {source: "Incident.shooting", searchable: false},
      location_of_occurrence: {source: "Incident.location_of_occurrence"},
      street: {source: "Incident.street"},
      nature_of_incident: {source: "Incident.nature_of_incident"},
      offenses: {source: "Offense.description"},
      incident_officers: {source: "IncidentOfficer.journal_officer"}
      # officers: {searchable: false, orderable: false}

      # id: { source: "User.id", cond: :eq },
      # name: { source: "User.name", cond: :like }
    }
  end

  def data
    records.map do |record|
      {
        url: incident_path(record),
        incident_number: record.incident_number,
        occurred_on_date: record.occurred_on_date,
        district: record.district,
        shooting: record.shooting,
        location_of_occurrence: record.location_of_occurrence,
        street: record.street,
        nature_of_incident: record.nature_of_incident,
        incident_officers: record.incident_officers.map(&:employee_name),
        offenses: record.offenses.map(&:description)
      }
    end
  end

  def get_raw_records
    q = Incident.includes(:incident_officers, :offenses).references(:incident_officers, :offenses).distinct
    if params[:officer_id]
      q = q.where("incident_officers.officer_id" => params[:officer_id])
    end
    q
  end

end
