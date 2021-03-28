class OfficersController < ApplicationController
  include Datatableable

  before_action :require_login, only: [:confirm_all_articles]

  def datatable_class
    OfficerDatatable
  end

  def index
  end

  def show
    @officer = Officer.includes(:compensations, :complaints).find_by!(employee_id: params[:id].to_i)
    redirect_to(@officer, status: 301) if params[:id] != @officer.to_param
    @attributions = [
      @officer.compensations.flat_map(&:attributions),
      @officer.attributions,
      @officer.pension && @officer.pension.attributions
    ].flatten.compact.uniq
    @latest_compensation = @officer.latest_compensation
    @sustained_allegations = @officer.ia_sustained_allegations.sort_by { |co| co.complaint.received_date || "0000-00-00" }.reverse
    @concerning_articles_officers = @officer.articles_officers.confirmed.includes(:article).where(concerning: true).sort_by { |ao| ao.article.date_published || "0000-00-00" }.reverse
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
      if ao.status == 'added'
        ao.status = 'confirmed'
        ao.save
      end
    end
    redirect_to officer_path(@officer, anchor: "articles")
  end

  def field_contacts
    @officer = Officer.includes(:field_contacts, :field_contact_names).find_by!(employee_id: params[:id].to_i)
  end
end
