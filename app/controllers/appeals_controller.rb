class AppealsController < ApplicationController
  def index
    if params[:q]
      @q = params[:q]
      @appeals = Appeal.search_for(params[:q]).page(params[:page])
    end
  end

  def show
    @appeal = Appeal.find_by!(case_no: params[:id])
  end
end
