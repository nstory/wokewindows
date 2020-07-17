class ArticleDatatable < ApplicationDatatable
  def view_columns
    @view_columns ||= {
      date_published: {source: "Article.date_published"},
      title: {source: "Article.title"},
      source: {orderable: false, searchable: false}
    }
  end

  def data_record(record)
    {
      date_published: record.article.date_published,
      title: record.article.title,
      url: record.article.url,
      source: record.article.source
    }
  end

  def get_raw_records
    ArticlesOfficer.includes(:article).references(:article).where(officer_id: params["officer_id"])
  end
end
