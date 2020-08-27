class Exporter::ComplaintsOfficersExporter < Exporter::Exporter
  def column_definitions
    column("ia_number") { record.complaint.ia_number }
    column("case_number") { record.complaint.case_number }
    column("incident_type") { record.complaint.incident_type }
    column("received_date") { record.complaint.received_date }
    column("occurred_date") { record.complaint.occurred_date }
    column("summary") { record.complaint.summary }
    column("name") { record.name }
    column("title") { record.title }
    column("badge") { record.badge }
    column("allegation") { record.allegation }
    column("finding") { record.finding }
    column("finding_date") { record.finding_date }
    prefix("officer", Exporter::OfficersExporter) { record.officer }
  end

  def records
    ComplaintOfficer.includes(:complaint, :officer)
  end
end
