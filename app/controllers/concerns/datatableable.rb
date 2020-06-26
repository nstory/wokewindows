module Datatableable
  extend ActiveSupport::Concern

  def datatable
    render json: datatable_class.new(params, view_context: view_context)
  end
end
