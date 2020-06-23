class ComplaintDatatable < ApplicationDatatable
  def view_columns
    @view_columns ||= {
      ia_number: {source: "Complaint.ia_number"},
      case_number: {source: "Complaint.case_number"},
      incident_type: {source: "Complaint.incident_type"},
      received_date: {source: "Complaint.received_date"},
      occurred_date: {source: "Complaint.occurred_date"},
      complaint_officers: {source: "ComplaintOfficer.name"}
    }
  end

  def data
    records.map do |record|
      {
        url: complaint_path(record),
        ia_number: record.ia_number,
        case_number: record.case_number,
        incident_type: record.incident_type,
        received_date: record.received_date,
        occurred_date: record.occurred_date,
        complaint_officers: record.complaint_officers.map(&:name)
      }
    end
  end

  def get_raw_records
    q = Complaint.includes(:complaint_officers).references(:complaint_officers).distinct
    if params[:officer_id]
      q = q.where("complaint_officers.officer_id" => params[:officer_id])
    end
    q
  end
end
