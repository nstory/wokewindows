class OfficersController < ApplicationController
  include Datatableable

  before_action :require_login, only: [:confirm_all_articles]

  def datatable_class
    OfficerDatatable
  end

  def index
  end

  def show
    @officer = Officer.includes(:compensations).find_by!(employee_id: params[:id])
    @attributions = [
      @officer.compensations.flat_map(&:attributions),
      @officer.attributions
    ].flatten.uniq
  end

  def select2
    officers = params.fetch(:q, "").split(/\s+/).inject(Officer.all) do |q,w|
      like = "%#{w}%"
      q.where('hr_name ILIKE ? OR journal_name ILIKE ?', like, like)
    end.limit(10)

    render json: {
      results: officers.map { |o| {id: o.id, text: "#{o.name} (#{o.employee_id}) - #{o.title}"} }
    }
  end

  def confirm_all_articles
    @officer = Officer.find_by(employee_id: params[:id])
    @officer.articles_officers.each do |ao|
      ao.confirmed = true
      ao.save
    end
    redirect_to officer_path(@officer, anchor: "articles")
  end
end
