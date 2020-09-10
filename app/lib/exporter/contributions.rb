class Exporter::Contributions < Exporter::Exporter
  def column_definitions
    column("date") { record.date }
    column("contributor") { record.contributor }
    column("zip") { write_zip_code(record.zip) }
    column("employer") { record.employer }
    column("occupation") { record.occupation }
    column("amount") { write_money(record.amount) }
    column("committee_name") { record.committee_name }
    column("cpf_id") { record.cpf_id }
    column("candidate_full_name") { record.candidate_full_name }
    column("office_type") { record.office_type }
    column("district") { record.district }
    column("party_affiliation") { record.party_affiliation }
    column("committee_id") { record.committee_id }
    column("memo_text") { record.memo_text }
    column("receipt_type_full") { record.receipt_type_full }
    prefix("officer", Exporter::Officers) { record.officer }
  end

  def records
    Contribution.includes(:officer, officer: [:zip_code, :complaint_officers, :complaints, complaint_officers: [:complaint]])
  end
end
