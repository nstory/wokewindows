class ArticlesController < ApplicationController
  include Datatableable

  def datatable_class
    ArticleDatatable
  end
end
