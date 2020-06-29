module Datatableable
  extend ActiveSupport::Concern

  included do
    skip_before_action :verify_authenticity_token, only: [:datatable]
  end

  def datatable
    datatable = datatable_class.new(params, view_context: view_context)
    if request.format == :csv
      response.headers["Content-Type"] = "application/csv"
      response.headers.delete("Content-Length")
      response.headers["Cache-Control"] = "no-cache"
      response.headers["Last-Modified"] = Time.now.httpdate.to_s
      response.headers["X-Accel-Buffering"] = "no"
      response.headers["Content-Disposition"] = ActionDispatch::Http::ContentDisposition.format(
        disposition: "attachment", filename: "download.csv"
      )
      self.response_body = Enumerator.new do |y|
        datatable.write_csv(y)
      end
    else
      render json: datatable
    end
  end
end
