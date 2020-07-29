class ArticleDatatable < ApplicationDatatable
  def view_columns
    @view_columns ||= {
      article_url: {searchable: false, orderable: false},
      date_published: {source: "Article.date_published"},
      title: {source: "Article.title"},
      source: {source: "Article.url", searchable: false},
      excerpt: {orderable: false, searchable: false}
    }
  end

  def data_record(record)
    {
      article_url: signed_in? && edit_article_url(record.article),
      date_published: record.article.date_published,
      title: record.article.title,
      url: record.article.url,
      source: record.article.source,
      excerpt: record.excerpt,
      status: record.status
    }
  end

  def get_raw_records
    ArticlesOfficer.includes(:article).references(:article).where(officer_id: params["officer_id"]).where(status: ["added", "confirmed"])
  end
end
