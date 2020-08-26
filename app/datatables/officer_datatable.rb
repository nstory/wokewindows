class OfficerDatatable < ApplicationDatatable
  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format
    @view_columns ||= {
      employee_id: {source: "Officer.employee_id", cond: :eq},
      badge: {source: "Officer.badge", searchable: false},
      name: {source: "Officer.hr_name", searchable: false},
      title: {source: "Officer.title", searchable: false},
      organization: {source: "Officer.organization", searchable: false},
      doa: {source: "Officer.doa", searchable: false},
      regular: {source: "Officer.regular", searchable: false, nulls_last: true},
      retro: {source: "Officer.retro", searchable: false, nulls_last: true},
      other: {source: "Officer.other", searchable: false, nulls_last: true},
      overtime: {source: "Officer.overtime", searchable: false, nulls_last: true},
      injured: {source: "Officer.injured", searchable: false, nulls_last: true},
      detail: {source: "Officer.detail", searchable: false, nulls_last: true},
      quinn: {source: "Officer.quinn", searchable: false, nulls_last: true},
      total: {source: "Officer.total", searchable: false, nulls_last: true},
      articles_officers_count: {source: "Officer.articles_officers_count", searchable: false},
      ia_score: {source: "Officer.ia_score", searchable: false},
      details_count: {source: "Officer.details_count", searchable: false},
      field_contacts_count: {source: "Officer.field_contacts_count", searchable: false},
      incidents_count: {source: "Officer.incidents_count", searchable: false},
      swats_count: {source: "Officer.swats_count", searchable: false},
      citations_count: {source: "Officer.citations_count", search: false},
      postal: {source: "Officer.postal", cond: :eq},
      state: {source: "ZipCode.state", searchable: false},
      neighborhood: {source: "ZipCode.city", searchable: false, orderable: false},
      bag_of_text: {source: "Officer.bag_of_text", searchable: true, orderable: false}
    }
  end

  def data_record(record)
    {
      url: officer_url(record),
      employee_id: record.employee_id,
      badge: record.badge,
      name: record.name,
      title: record.title,
      organization: record.organization,
      doa: record.doa,
      total: record.total,
      regular: record.regular,
      retro: record.retro,
      other: record.other,
      overtime: record.overtime,
      injured: record.injured,
      detail: record.detail,
      quinn: record.quinn,
      details_count: record.details_count,
      articles_officers_count: record.articles_officers_count,
      articles_officers_to_review_count: signed_in? && record.articles_officers_to_review_count,
      ia_score: record.ia_score,
      field_contacts_count: record.field_contacts_count,
      incidents_count: record.incidents_count,
      swats_count: record.swats_count,
      citations_count: record.citations_count,
      postal: record.postal,
      state: record.zip_code && record.zip_code.state,
      neighborhood: record.zip_code && record.zip_code.neighborhood_or_city
    }
  end

  def get_raw_records
    Officer.includes(:zip_code, :articles_officers).references(:zip_code).distinct
  end
end
