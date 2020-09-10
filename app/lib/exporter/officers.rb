class Exporter::Officers < Exporter::Exporter
  def column_definitions
    column("active") { write_boolean(record.active) }
    column("employee_id") { record.employee_id }
    column("name") { record.name }
    column("organization") { record.organization }
    column("title") { record.title }
    column("doa") { record.doa }
    column("badge") { record.badge }
    column("zip_code") { write_zip_code(record.postal) }
    column("city") { record.zip_code ? record.zip_code.city : nil }
    column("state") { record.zip_code ? record.zip_code.state : nil }
    column("neighborhood") { record.zip_code ? record.zip_code.neighborhood : nil }
    column("regular") { write_money(record.regular) }
    column("retro") { write_money(record.retro) }
    column("other") { write_money(record.other) }
    column("overtime") { write_money(record.overtime) }
    column("injured") { write_money(record.injured) }
    column("detail") { write_money(record.detail) }
    column("quinn") { write_money(record.quinn) }
    column("total") { write_money(record.total) }
    column("rank") { record.rank }
    column("ia_score") { record.ia_score }
    column("ia_sustained_conduct_unbecoming") { record.ia_sustained_conduct_unbecoming.count }
    column("ia_sustained_neg_duty") { record.ia_sustained_neg_duty.count }
    column("ia_sustained_respectful_treatment") { record.ia_sustained_respectful_treatment.count }
    column("ia_sustained_self_identification") { record.ia_sustained_self_identification.count }
    column("ia_sustained_use_of_force") { record.ia_sustained_use_of_force.count }
    column("ia_sustained_details") { record.ia_sustained_details.count }
    column("ia_sustained_cases") { record.ia_sustained_complaints.count }
    column("ia_sustained_allegations") { record.ia_sustained_allegations.count }
    column("ia_cases") { record.ia_complaints }
    column("ia_allegations") { record.ia_allegations }
    column("field_contacts_count") { record.field_contacts_count }
    column("incidents_count") { record.incidents_count }
    column("complaints_count") { record.complaints_count }
    column("swats_count") { record.swats_count }
    column("details_count") { record.details_count }
    column("citations_count") { record.citations_count }
    column("articles_officers_count") { record.articles_officers_count }
    column("url") { officer_url(record) }
  end

  def records
    Officer.includes(:zip_code, :complaint_officers, :complaints, complaint_officers: [:complaint])
  end
end
