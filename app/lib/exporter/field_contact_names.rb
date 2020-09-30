class Exporter::FieldContactNames < Exporter::Exporter
  def column_definitions
    column("fc_num") { record.fc_num }
    column("race") { record.race }
    column("age") { record.age }
    column("build") { record.build }
    column("hair_style") { record.hair_style }
    column("skin_tone") { record.skin_tone }
    column("ethnicity") { record.ethnicity }
    column("other_clothing") { record.other_clothing }
    column("license_state") { record.license_state }
    column("license_type") { record.license_type }
    column("frisked_searched") { write_boolean(record.frisked_searched) }
    column("gender") { record.gender }
    prefix("field_contact", Exporter::FieldContacts) { record.field_contact }
  end

  def records
    FieldContactName.includes(:field_contact, field_contact: [contact_officer: [:pension, :zip_code, :complaint_officers, :complaints, complaint_officers: [:complaint]]])
  end
end
