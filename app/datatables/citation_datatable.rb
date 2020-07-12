class CitationDatatable < ApplicationDatatable
  def view_columns
    @view_columns ||= {
      ticket_number: {source: "Citation.ticket_number", searchable: false},
      location_name: {source: "Citation.location_name", searchable: false},
      event_date: {source: "Citation.event_date", searchable: false, nulls_last: true},
      amount: {source: "Citation.amount", searchable: false},
      issuing_agency: {source: "Citation.issuing_agency", searchable: false},
      ticket_type: {source: "Citation.ticket_type", searchable: false},
      source: {source: "Citation.source", searchable: false},
      violator_type: {source: "Citation.violator_type", searchable: false},
      cdl: {source: "Citation.cdl", searchable: false},
      license_class: {source: "Citation.license_class", searchable: false},
      posted_speed: {source: "Citation.posted_speed", searchable: false},
      violation_speed: {source: "Citation.violation_speed", searchable: false},
      posted: {source: "Citation.posted", searchable: false},
      radar: {source: "Citation.radar", searchable: false},
      clocked: {source: "Citation.clocked", searchable: false},
      race: {source: "Citation.race", searchable: false},
      sex: {source: "Citation.sex", searchable: false},
      vehicle_color: {source: "Citation.vehicle_color", searchable: false},
      make: {source: "Citation.make", searchable: false},
      model_year: {source: "Citation.model_year", searchable: false},
      sixteen_pass: {source: "Citation.sixteen_pass", searchable: false},
      haz_mat: {source: "Citation.haz_mat", searchable: false},
      paid: {source: "Citation.paid", searchable: false},
      hearing_requested: {source: "Citation.hearing_requested", searchable: false},
      court_name: {source: "Citation.court_code", searchable: false},
      age: {source: "Citation.age", searchable: false},
      searched: {source: "Citation.searched", searchable: false},
      offenses: {source: "Citation.offenses", searchable: false, orderable: false},
      bag_of_text: {source: "Citation.bag_of_text", searchable: true, orderable: false}
    }
  end

  def data_record(record)
    {
      url: citation_url(record),
      ticket_number: record.ticket_number,
      location_name: record.location_name,
      event_date: record.event_date,
      amount: record.amount,
      issuing_agency: record.issuing_agency,
      ticket_type: record.ticket_type,
      source: record.source,
      violator_type: record.violator_type,
      cdl: record.cdl,
      license_class: record.license_class,
      posted_speed: record.posted_speed,
      violation_speed: record.violation_speed,
      posted: record.posted,
      radar: record.radar,
      clocked: record.clocked,
      race: record.race,
      sex: record.sex,
      vehicle_color: record.vehicle_color,
      make: record.make,
      model_year: record.model_year,
      sixteen_pass: record.sixteen_pass,
      haz_mat: record.haz_mat,
      paid: record.paid,
      hearing_requested: record.hearing_requested,
      court_name: record.court_name,
      age: record.age,
      searched: record.searched,
      offenses: record.offenses.map(&:description),
      officer_number: record.officer_number,
      officer_name: record.officer ? record.officer.name : nil,
      officer_url: record.officer ? officer_url(record.officer) : nil
    }
  end

  def get_raw_records
    q = Citation.includes(:officer).all
    if params[:officer_id]
      q = q.where("officer_id" => params[:officer_id])
    end
    q
  end
end
