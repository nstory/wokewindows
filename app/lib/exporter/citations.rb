class Exporter::Citations < Exporter::Exporter
  def column_definitions
    column("ticket_number") { record.citation.ticket_number }
    column("issuing_agency") { record.citation.issuing_agency }
    column("officer_number") { record.citation.officer_number }
    column("ticket_type") { record.citation.ticket_type }
    column("source") { record.citation.source }
    column("violator_type") { record.citation.violator_type }
    column("cdl") { record.citation.cdl }
    column("license_class") { record.citation.license_class }
    column("event_date") { record.citation.event_date }
    column("location_id") { record.citation.location_id }
    column("location_name") { record.citation.location_name }
    column("posted_speed") { record.citation.posted_speed }
    column("violation_speed") { record.citation.violation_speed }
    column("posted") { write_boolean(record.citation.posted) }
    column("radar") { write_boolean(record.citation.radar) }
    column("clocked") { write_boolean(record.citation.clocked) }
    column("race") { record.citation.race }
    column("sex") { record.citation.sex }
    column("vehicle_color") { record.citation.vehicle_color }
    column("make") { record.citation.make }
    column("model_year") { record.citation.model_year }
    column("sixteen_pass") { write_boolean(record.citation.sixteen_pass) }
    column("haz_mat") { write_boolean(record.citation.haz_mat) }
    column("amount") { write_money(record.citation.amount) }
    column("paid") { write_boolean(record.citation.paid) }
    column("hearing_requested") { write_boolean(record.citation.hearing_requested) }
    column("court_code") { record.citation.court_code }
    column("age") { record.citation.age }
    column("searched") { write_boolean(record.citation.searched) }
    column("offense") { record.offense.offense }
    column("description") { record.offense.description }
    column("assessment") { write_money(record.offense.assessment) }
    column("expected_assessment") { write_money(record.offense.expected_assessment) }
    column("display_assessment") { write_money(record.offense.display_assessment) }
    column("disposition") { record.offense.disposition }
    column("disposition_description") { record.offense.disposition_description }
    column("major_incident") { write_boolean(record.offense.major_incident) }
    column("surchargeable") { write_boolean(record.offense.surchargeable) }
    column("sdip_points") { record.offense.sdip_points }
    prefix("officer", Exporter::Officers) { record.citation.officer }
  end

  def records
    Citation.includes(:officer, officer: [:zip_code, :complaint_officers, :complaints, complaint_officers: [:complaint]]).flat_map do |cit|
      cit.offenses.map do |off|
        OpenStruct.new offense: off, citation: cit
      end
    end
  end
end
