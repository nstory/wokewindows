class AppealsController < ApplicationController
  def index
    if params[:q]
      @q = params[:q]
      @appeals = search.page(params[:page])
    end
  end

  def csv
    appeals = search.limit(9999)
    send_data generate_csv(appeals), filename: "appeals.csv", type: "text/csv", disposition: "attachment"
  end

  def show
    @appeal = Appeal.find_by!(case_no: params[:id])
  end

  private
  def search
    Appeal.search_for(params[:q]).order(case_no: :desc)
  end

  def generate_csv(appeals)
    fields = %w{case_no requester custodian resp_prov_date date_opened date_closed}
    out = [*fields, "url", "text"].to_csv
    appeals.each do |a|
      out += [
        *(fields.map { |f| a.send(f) }),
        helpers.appeal_url(a),
        truncate_middle(a.decisions_text, length: 2000)
      ].to_csv
    end
    out
  end

  def truncate_middle(text, length: 1000)
    return text if !text || text.length <= length
    "#{text[0 ... length/2]} ... #{text[-(length/2) .. -1]}"
  end
end
