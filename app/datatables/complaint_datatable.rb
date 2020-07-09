class ComplaintDatatable < ApplicationDatatable
  def view_columns
    @view_columns ||= {
      ia_number: {source: "Complaint.ia_number", searchable: false},
      incident_type: {source: "Complaint.incident_type", searchable: false},
      received_date: {source: "Complaint.received_date", searchable: false, nulls_last: true},
      occurred_date: {source: "Complaint.occurred_date", searchable: false, nulls_last: true},
      complaint_officers: {source: "ComplaintOfficer.name", searchable: false},
      bag_of_text: {source: "Complaint.bag_of_text", searchable: false, orderable: false}
    }
  end

  def data_record(record)
    {
      url: complaint_url(record),
      ia_number: record.ia_number,
      incident_type: record.incident_type,
      received_date: record.received_date,
      occurred_date: record.occurred_date,
      finding: record.finding,
      complaint_officers: record.complaint_officers.map(&:name).uniq
    }
  end

  def get_raw_records
    q = Complaint.includes(:complaint_officers).references(:complaint_officers).distinct
    if params[:officer_id]
      q = q.where("complaint_officers.officer_id" => params[:officer_id])
    end
    q
  end
end
